from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
from django.http import HttpResponseRedirect
from django.urls import reverse
from django.utils.encoding import smart_str
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.utils.html import escape
from django.db.models import Q
from django.core.files.storage import FileSystemStorage
from django.conf import settings
import audioread
import subprocess
import re

from . models import Genre
from . models import Artist
from . models import Album
from . models import Song
from . models import Playlist

def index(request):
    genres = Genre.objects.all().order_by("genre")
    data = {"genres": genres}
    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user).order_by('name')
        data["playlists"] = playlists
    return render(request, "songs/index.html", context=data)

def user_sign_up(request):
        return render(request, "users/sign_up.html", {"message": ""})

def create_account(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        retyped_password = request.POST["retyped_password"]

        user = User.objects.filter(username=username).count()
        
        if user > 0:
            return render(request, "users/sign_up.html", {"error_message": "Username " + username + " was already taken."})
        elif password != retyped_password:
            return render(request, "users/sign_up.html", {"error_message": "Your password mismatched."})        
        else:
            if len(username.strip()) >= 5: # Proceed creating new account
                if len(password.strip()) >= 8:
                    new_user = User.objects.create(username=username, password=make_password(password), is_staff="f") 
                    new_user.save()

                    return render(request, "users/sign_up.html", {"success_message": "Your account has been successfully created."})
                else:
                    return render(request, "users/sign_up.html", {"error_message": "Password should be at least 8 characters long."})
            else:
                return render(request, "users/sign_up.html", {"error_message": "Username should be at least 5 characters long."})  

@login_required
def user_display_profile(request, username):
    playlists = Playlist.objects.filter(user=request.user).order_by("-id")
    data = {"playlists": playlists}
    return render(request, "users/profile.html", data)
    
@login_required
def change_username(request):
    if request.method == "POST":
        new_username = request.POST["new_username"]
        
        user = User.objects.get(username=request.user)
        user.username = new_username
        user.save()
        data = {"message": "Your username has successfully changed to " + new_username}
        return JsonResponse(data)
    else:
        data = {"message": "You're not allowed to do this."}
        return JsonResponse(data)

@login_required
def change_password(request):
    if request.method == "POST":
        user = User.objects.get(username=request.user)

        actual_current_password = user.password
        current_password = make_password(request.POST["current_password"])

        if current_password == actual_current_password:
            user.password = make_password(request.POST["new_password"])
            user.save()
        else:
            data = {"message": "current password incorrect", "current_password": user.password, "entered_current_password": make_password(request.POST["current_password"]), "new_password": request.POST["new_password"]}
            return JsonResponse(data)
    else:
        data = {"message": "You're not allowed to do this."}
        return JsonResponse(data)

def list_songs_based_on_genre(request, genre_id):
    genre = Genre.objects.get(id=genre_id)
    songs = genre.song_set.all().order_by("title")
    # songs = Song.objects.filter(genre__id=genre_id)
    data = {"songs": songs, "genre": genre}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user).order_by("name")
        data["playlists"] = playlists
    return render(request, "songs/genre_songs.html", data)

def search_song(request):
    # search_filter = request.GET["search_filter"]
    search_keyword = request.GET["search_keyword"]
    songs = Song.objects.filter(Q(title__icontains=search_keyword) | Q(genre__genre__icontains=search_keyword) | Q(album__title__icontains=search_keyword) | Q(album__artist__name__icontains=search_keyword)).order_by("title").distinct()

    data = {"songs": songs, "search_keyword": search_keyword}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user).order_by("name")
        data["playlists"] = playlists
    return render(request, "songs/search_songs.html", data)

def download_song(request):
    path = request.GET["path"]
    path = settings.MEDIA_ROOT+"/audios/"+path
    with open(path, 'rb') as mp3:
        response = HttpResponse(mp3, content_type="audio/mpeg") 
        # without the below line, the browser will play it.
        response["Content-disposition"] = "attachment; filename=%s" % smart_str(path)
        return response

def display_playlist(request):
    data = {}
    playlists = Playlist.objects.filter(user=request.user).order_by("name")
    data["playlists"] = playlists
    return render(request, "songs/display_playlist.html", data)

def play_song(request, song_id):
    path = request.POST["path"]
    file_name = path[path.index("/")+1:]
    path = "/media/"+ file_name 
    return render(request, "songs/player.html", {"path": path})

@login_required
def add_playlist(request):
    if request.user.is_authenticated:
        if request.method == "POST":
            title = request.POST["title"]
            user = request.user

            try:
                check_if_playlist_exist = Playlist.objects.get(user=user, name__iexact=title)
                data = {"message": "exist", "playlist_id": check_if_playlist_exist.id}

            except Playlist.DoesNotExist:
                playlist = Playlist.objects.create(name=title, user=user)
                playlist.save()

                playlist_id = Playlist.objects.latest("id").id

                data = {"message": "New playlist was successfully created.", "playlist_id": playlist_id}
        else:
            data = {"message": "Method used was " + str(request.method)}
    else:
        data = {"message": "User is not authenticated."}
    return JsonResponse(data)

@login_required
def playlist_songs(request, playlist_id):
    playlist = Playlist.objects.get(pk=playlist_id)
    playlist_songs = playlist.song.values_list("pk", flat=True)

    songs = Song.objects.filter(id__in=playlist_songs).order_by("title")
    
    data = {"songs": songs, "playlist": playlist}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user).order_by("name")
        data["playlists"] = playlists
    return render(request, "songs/playlist_songs.html", data)

@login_required
def add_song_to_a_playlist(request):
    if request.method == "POST":
        song_id = request.POST["song_id"]
        playlist_id = request.POST["playlist_id"]

        song = Song.objects.get(id=song_id)
        playlist = Playlist.objects.get(id=playlist_id)
        # playlist_song = playlist.song.create(song=song)
        song_playlist = song.playlist_set.add(playlist)

        data = {"message": song.title + " was added to the playlist " + playlist.name, "song": song.title, "playlist": playlist.name}
        return JsonResponse(data)

@login_required
def remove_song_from_a_playlist(request):
    if request.method == "POST":
        song_id = request.POST["song_id"]
        playlist_id = request.POST["playlist_id"]

        playlist = Playlist.objects.get(id=playlist_id)
        song = Song.objects.get(id=song_id)
        playlist.song.remove(song)

        data = {"message": song.title + " was removed from playlist " + playlist.name, "song": song.title, "playlist": playlist.name}
        return JsonResponse(data)

@login_required
def delete_playlist(request):
    if request.method == "POST":
        playlist_id = request.POST["playlist_id"]

        Playlist.objects.filter(id=playlist_id).delete()
        data = {"message": "Playlist with ID" + str(playlist_id) + " was removed."}
        return JsonResponse(data)

@login_required
def rename_playlist(request):
    if request.method == "POST":
        playlist_id = request.POST["playlist_id"]
        new_name = request.POST["new_name"]

        playlist = Playlist.objects.get(id=playlist_id)
        playlist.name = new_name
        playlist.save()

        data = {"message": "Playlist with ID" + str(playlist_id) + " was successfully renamed to " + new_name + "."}
        return JsonResponse(data)


# Admin Views

def data_man_landing(request):
    logout(request)
    return render(request, "data_man/login.html")

def data_man_login(request):
    # logout(request)
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        user = authenticate(username=username, password=password)
        if user is not None:
            if user.is_staff:
                if user.is_active:
                    data = {"message": "success"}
                    login(request, user)
                    # return data_man_dashboard(request)
            else:
                data = {"message": "You do not have the privilege to get in."}
        else:
            data = {"message": "Your username and password combination does not exist."}
    else:
        data = {"message": "You are not allowed to do this."}
    
    return JsonResponse(data)

def data_man_logout(request):
    logout(request)
    return HttpResponseRedirect(reverse('data_man_landing'))
    

def data_man_dashboard(request):
    total_num_of_songs = Song.objects.count()
    total_num_of_genres = Genre.objects.count()
    total_num_of_artists = Artist.objects.count()
    total_num_of_albums = Album.objects.count()

    data = {"total_num_of_songs": total_num_of_songs, "total_num_of_genres": total_num_of_genres, "total_num_of_artists": total_num_of_artists, "total_num_of_albums": total_num_of_albums} 
    return render(request, "data_man/dashboard.html", data)



def data_man_songs(request):
    songs = Song.objects.all().order_by("title")
    genres = Genre.objects.all().order_by("genre")
    albums = Album.objects.all().order_by("title")

    data = {"songs": songs, "genres": genres, "albums": albums}
    return render(request, "data_man/songs.html", data)

def get_audio_duration(filename):
    # valid for any audio file accepted by ffprobe
    args = ("ffprobe", "-show_entries", "format=duration", "-i", settings.MEDIA_ROOT+"/"+filename)
    popen = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, err = popen.communicate()
    match = re.search(r"[-+]?\d*\.\d+|\d+", output)
    return float(match.group())

def handle_uploaded_file(path, name):
    audio_file =  open(settings.MEDIA_ROOT+"/audios/"+name, 'wb+')
    for chunk in path.chunks():
        audio_file.write(chunk)
    audio_file.close()


def add_song(request):
    if request.method == "POST":
        size = float(request.POST["size"])
        size = round(size/1048576, 2)
        if size > 10:
            data = {"message": "File is too big."}
        else:
            title = request.POST["title"]
            album_id = request.POST["album"]
            genre_ids = request.POST["genres"].split(",")
            audio_format = request.POST["type"]  

            audio_file = request.FILES["audio"]
           
            handle_uploaded_file(audio_file, audio_file.name)

            album = Album.objects.get(id=album_id)
            with audioread.audio_open(settings.MEDIA_ROOT+"/audios/"+audio_file.name) as f:
                duration = f.duration
            duration = round(duration/60, 2)

            song = Song.objects.create(title=title, album=album, path=audio_file.name, audio_format=audio_format, duration=duration, size=size)
            song.save()

            new_song_id = Song.objects.latest("id").id
            new_song = Song.objects.get(id=new_song_id)

            for genre_id in genre_ids:
                genre = Genre.objects.get(id=genre_id)
                genre.song_set.add(new_song)

        data = {"message": "GOT DATA", "genres": genre_ids, "name": audio_file.name, "duration": duration}
    else:
        data = {"message": "Method should be post."}

    return JsonResponse(data)

def data_man_albums(request):
    artists = Artist.objects.all().order_by("name")
    genres = Genre.objects.all().order_by("genre")

    albums = Album.objects.all().order_by("title")

    album_data = []

    for album in albums:
        songs = Song.objects.filter(album=album)
        album_data.append({"album": album, "songs": songs})

    data = {"artists": artists, "genres": genres, "album_data": album_data}


    return render(request, "data_man/albums.html", data)

def add_album(request):
    if request.method == "POST":
        title = request.POST["title"]
        artist_id = request.POST["artist"]
        cover = request.FILES["cover"]

        artist = Artist.objects.get(id=artist_id)

        album = Album.objects.filter(Q(title=title), Q(artist=artist)).count()

        if(album > 0):
            data = {"message": "That album of " + str(artist.name) + " already exist."}
        else:
            new_album = Album.objects.create(title=title, artist=artist, cover=cover)
            data = {"message": "successful"}
    else:
        data = {"message": "Method is not post"}

    return JsonResponse(data)

def add_album_with_songs(request):
    if request.method == "POST":
        album_title = request.POST["album_title"]
        artist_id = request.POST["artist"]
        artist = Artist.objects.get(id=artist_id)

        album = Album.objects.create(title=album_title, artist=artist)
        album.save()

        new_album_id = Album.objects.latest("id").id
        new_album = Album.objects.get(id=new_album_id)

        number_of_songs_to_add = request.POST["number_of_songs_to_add"]

        for i in range(1, int(number_of_songs_to_add)+1):
            song_title = request.POST["song_title_"+str(i)]
            size = request.POST["size_"+str(i)]
            size = round(size, 2)
            audio_format = request.POST["audio_format_"+str(i)]
            audio_file = request.FILES["audio_file_"+str(i)]

            handle_uploaded_file(audio_file, audio_file.name)

            with audioread.audio_open(settings.MEDIA_ROOT+"/audios/"+audio_file.name) as f:
                duration = f.duration
            duration = round(duration/60, 2)

            song = Song.objects.create(title=song_title, album=new_album, path=audio_file.name, audio_format=audio_format, duration=duration, size=size)
            song.save()

            new_song_id = Song.objects.latest("id").id
            new_song = Song.objects.get(id=new_song_id)

            genre_ids = request.POST["genres_"+str(i)].split(",")

            for genre_id in genre_ids:
                genre = Genre.objects.get(id=genre_id)
                genre.song_set.add(new_song)
        data = {"message": "success", "genres": genre_ids, "name": audio_file.name, "duration": duration}
    else:
        data = {"message": "incorrect method"}

    return JsonResponse(data)

def data_man_artists(request):
    artists = Artist.objects.all().order_by("name")

    artists_data = []

    for artist in artists:
        albums = Album.objects.filter(artist=artist).order_by("title")
        artists_data.append({"artist": artist, "albums": albums})

    data = {"artists_data": artists_data}
    return render(request, "data_man/artists.html", data)

def add_artist(request):
    if request.method == "POST":
        name = request.POST["name"]
        artist_exist = Artist.objects.filter(name=name).count()

        if(artist_exist > 0):
            data = {"message": "artist exists"}

        else:
            artist = Artist.objects.create(name=name)
            artist.save()
            data = {"message": "success"}

        
    else:
        data = {"message": "incorrect method"}

    return JsonResponse(data)

def data_man_genres(request):
    genres = Genre.objects.all().order_by("genre")

    genres_data = []

    for genre in genres:
        songs = genre.song_set.all().order_by("title")
        genres_data.append({"genre": genre, "songs": songs})
        

    data = {"genres_data": genres_data}
    return render(request, "data_man/genres.html", data)

def add_genre(request):
    if request.method == "POST":
        genre = request.POST["genre"]
        genre_exists = Genre.objects.filter(genre=genre).count()

        if(genre_exists > 0):
            data = {"message": "genre exists"}
        else:
            genre_image = request.FILES["genre_image"]
            genre = Genre.objects.create(genre=genre, image=genre_image)
            genre.save()
            data = {"message": "success"}

        
    else:
        data = {"message": "incorrect method"}

    return JsonResponse(data)

def data_man_search_song(request):
    search_keyword = request.GET["keyword"]

    songs = Song.objects.filter(Q(title__icontains=search_keyword) | Q(genre__genre__icontains=search_keyword) | Q(album__title__icontains=search_keyword) | Q(album__artist__name__icontains=search_keyword)).order_by("title").distinct()
    
    content = ""

    i = 1
    for song in songs:
        content += "<tr id='song_tr_" + str(song.id) + "' onmouseover=\"show_song_edit_icons('" + str(song.id) + "')\" onmouseout=\"hide_song_edit_icons('" + str(song.id) + "')\">"
        content += "<td title='Delete Song' onclick=\"delete_song('" + str(song.id) + "', '" + str(song.title) + "', '" + str(song.album.artist) + "')\"><i class='fa fa-trash'></i></td>"
        content += "<td>" + str(i) + "</td>"
        content += "<td id='td_song_title_" + str(song.id) + "'>" + str(song) + "  <sup style='visibility: hidden;' onclick=\"show_song_edit_title_form('" + str(song.id) + "', '" + str(song.title) + "')\"><i class='fa fa-edit song_edit_icon'></i></sup></td>"
        content += "<td id='song_artist_" + str(i) + "'>" + str(song.album.artist) + "</td>"
        content += "<td id='song_album_" + str(i) + "'>" + str(song.album) + "</td>"
        content += "<td id='song_genre_" + str(i) + "'>"
        for genre in song.genre.all():
            content += str(genre) + "; "
        content += "</td>"
        content += "<td>" + str(song.duration) + " mins</td>"
        content += "<td>" + str(song.size) + " MB </td>"
        content += "<td>" + str(song.audio_format) + "</td>"
        content += "</tr>"

        i += 1

    data = {"content": content}
    return JsonResponse(data)

def data_man_search_artist(request):
    search_keyword = request.GET["keyword"]

    artists = Artist.objects.filter(name__icontains=search_keyword).order_by("name")
    
    content = ""

    i = 1
    for artist in artists:
        content += "<tr>"
        content += "<td onclick=\"show_update_artist_form('" + str(artist.id) + "', '" + str(artist.name) + "' )\"><i class='fa fa-edit'></i></td>"
        content += "<td onclick=\"delete_artist('" + str(artist.id) + "', '" + str(artist.name) + "')\"><i class='fa fa-trash'></i></td>"
        content += "<td>" + str(i) + "</td>"
        content += "<td id='td_artist_" + str(artist.id) +  "'>" + str(artist.name) + "</td>"

        albums = Album.objects.filter(artist=artist).order_by("title")

        content += "<td><ol>"
        for album in albums:
            content += "<li>" + str(album.title) + "</li>"
        content += "</ol></td></tr>"

        i += 1

    data = {"content": content}
    return JsonResponse(data)

def data_man_search_album(request):
    search_keyword = request.GET["keyword"]

    albums = Album.objects.filter(title__icontains=search_keyword).order_by("title")
    
    content = ""

    i = 1
    for album in albums:
        content += "<tr>"
        content += "<td onclick=\"show_update_album_form('" + str(album.id) + "', '" + str(album) + "')\"><i class='fa fa-edit'></i></td>"
        content += "<td onclick=\"delete_album('" + str(album.id) + "', '" + str(album) + "')\"><i class='fa fa-trash'></i></td>"
        content += "<td>" + str(i) + "</td>"
        content += "<td><img height='50px' width='50px' src='/media/" + str(album.cover) + "' /></td>"
        content += "<td id='td_album_" + str(album.id) +"'>" + str(album.title) + "</td>"
        content += "<td>" + str(album.artist) + "</td>"

        songs = Song.objects.filter(album=album).order_by("title")

        content += "<td><ol>"
        for song in songs:
            content += "<li>" + str(song) + "</li>"
        content += "</ol></td></tr>"

        i += 1

    data = {"content": content}
    return JsonResponse(data)

def data_man_search_genre(request):
    search_keyword = request.GET["keyword"]

    genres = Genre.objects.filter(genre__icontains=search_keyword).order_by("genre")
    
    content = ""

    i = 1
    for genre in genres:
        content += "<tr>"
        content += "<td><i onclick=\"show_update_genre_form('" + str(genre.id) + "', '" + str(genre) + "')\" class='fa fa-edit'></i></td>"
        content += "<td><i onclick=\"delete_genre('" + str(genre.id) + "', '" + str(genre) + "')\" class='fa fa-trash'></i></td>"
        content += "<td>" + str(i) + "</td>"
        content += "<td><img height='50px' width='50px' src='/media/" + str(genre.image) + "' /></td>"
        content += "<td id='td_genre_" + str(genre.id) + "'>" + str(genre) + "</td>"

        songs = genre.song_set.all().order_by("title")
        
        content += "<td><ol>"
        for song in songs:
            content += "<li>" + str(song) + "</li>"
        content += "</ol></td></tr>"

        i += 1

    data = {"content": content}
    return JsonResponse(data)

def data_man_delete_song(request):
    song_id = request.POST["song_id"]
    Song.objects.filter(id=song_id).delete()
    data = {"message": "deleted"}

    return JsonResponse(data)

def data_man_update_artist(request):
    artist_id = request.POST["artist_id"]
    artist_name = request.POST["artist"]

    artist = Artist.objects.get(id=artist_id)
    artist.name = artist_name
    artist.save()

    data = {"message": "updated"}

    return JsonResponse(data)

def data_man_delete_artist(request):
    artist_id = request.POST["artist_id"]
    Artist.objects.filter(id=artist_id).delete()
    
    data = {"message": "deleted"}
    return JsonResponse(data)


def data_man_update_album(request):
    album_id = request.POST["album_id"]
    album_title = request.POST["album"]

    album = Album.objects.get(id=album_id)
    album.title = album_title
    album.save()

    data = {"message": "updated"}

    return JsonResponse(data)

def data_man_delete_album(request):
    album_id = request.POST["album_id"]
    Album.objects.filter(id=album_id).delete()
    
    data = {"message": "deleted"}
    return JsonResponse(data)

def data_man_update_genre(request):
    genre_id = request.POST["genre_id"]
    new_genre = request.POST["genre"]

    genre = Genre.objects.get(id=genre_id)
    genre.genre = new_genre
    genre.save()

    data = {"message": "updated"}

    return JsonResponse(data)

def data_man_delete_genre(request):
    genre_id = request.POST["genre_id"]
    Genre.objects.filter(id=genre_id).delete()
    
    data = {"message": "deleted"}
    return JsonResponse(data)

def data_man_song_edit_title(request):
    ID = request.POST["id"]
    title = request.POST["title"]

    song = Song.objects.get(id=ID)
    song.title = title
    song.save()

    data = {"message": "updated"}
    return JsonResponse(data)