from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
from django.utils.encoding import smart_str
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.utils.html import escape
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
    songs = Song.objects.filter(genre__id=genre_id)
    data = {"songs": songs, "genre": genre}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user).order_by('-id')
        data["playlists"] = playlists
    return render(request, "songs/genre_songs.html", data)

def search_song(request):
    search_filter = request.GET["search_filter"]
    search_keyword = request.GET["search_keyword"]

    if search_filter == "title":
        songs = Song.objects.filter(title__icontains=search_keyword)
    elif search_filter == "genre":
        songs = Song.objects.filter(genre__genre__icontains=search_keyword)
    elif search_filter == "album":
        songs = Song.objects.filter(album__title__icontains=search_keyword)
    else:
        songs = Song.objects.filter(album__artist__name__icontains=search_keyword)

    data = {"songs": songs, "search_filter": search_filter, "search_keyword": search_keyword}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user).order_by('-id')
        data["playlists"] = playlists
    return render(request, "songs/search_songs.html", data)

def download_song(request):
    path = request.GET["path"]
    with open(path, 'rb') as mp3:
        response = HttpResponse(mp3, content_type="audio/mpeg") 
        # without the below line, the browser will play it.
        response["Content-disposition"] = "attachment; filename=%s" % smart_str(path)
        return response

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

    songs = Song.objects.filter(id__in=playlist_songs)
    
    data = {"songs": songs, "playlist": playlist}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user).order_by('-id')
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

def data_man_dashboard(request):
    total_num_of_songs = Song.objects.count()
    total_num_of_genres = Genre.objects.count()
    total_num_of_artists = Artist.objects.count()
    total_num_of_albums = Album.objects.count()

    data = {"total_num_of_songs": total_num_of_songs, "total_num_of_genres": total_num_of_genres, "total_num_of_artists": total_num_of_artists, "total_num_of_albums": total_num_of_albums} 
    return render(request, "data_man/dashboard.html", data)



def data_man_songs(request):
    songs = Song.objects.all().order_by("title")
    genres = Genre.objects.all()
    albums = Album.objects.all()

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

        new_album = Album.objects.create(title=title, artist=artist, cover=cover)

        data = {"message": "successfully added album"}
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
            genre = Genre.objects.create(genre=genre)
            genre.save()
            data = {"message": "success"}

        
    else:
        data = {"message": "incorrect method"}

    return JsonResponse(data)