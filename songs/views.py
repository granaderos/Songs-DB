from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
from django.utils.encoding import smart_str
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
# from django.contrib.sessions.models import Session

from . models import Genre
from . models import Artist
from . models import Album
from . models import Song
from . models import Playlist

def index(request):
    genres = Genre.objects.all()
    data = {"genres": genres}
    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user)
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
            if len(username) >= 5 and len(username) <= 20: # Proceed creating new account
                if len(password) >= 8 and len(password) <= 30:
                    new_user = User.objects.create(username=username, password=make_password(password), is_staff="f") 
                    new_user.save()

                    return render(request, "users/sign_up.html", {"success_message": "Your account has been successfully created. "})
                else:
                    return render(request, "users/sign_up.html", {"error_message": "Password should be at least and at most 8 to 30 characters."})
            else:
                return render(request, "users/sign_up.html", {"error_message": "Username should be at least and at most 5 to 20 characters long."})


def list_songs_based_on_genre(request, genre_id):
    genre = Genre.objects.get(id=genre_id)
    songs = Song.objects.filter(genre_id=genre_id)
    data = {"songs": songs, "genre": genre}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user)
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
        playlists = Playlist.objects.filter(user=request.user)
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

def add_playlist(request):
    if request.user.is_authenticated:
        if request.method == "POST":
            title = request.POST["title"]
            user = request.user

            playlist = Playlist.objects.create(name=title, user=user)
            playlist.save()

            playlist_id = Playlist.objects.latest("id").id

            data = {"message": "New playlist was successfully created.", "playlist_id": playlist_id}
            return JsonResponse(data)

def playlist_songs(request, playlist_id):
    playlist = Playlist.objects.get(pk=playlist_id)
    playlist_songs = playlist.song.values_list("pk", flat=True)

    songs = Song.objects.filter(id__in=playlist_songs)
    
    data = {"songs": songs, "playlist": playlist}

    if request.user.is_authenticated:
        playlists = Playlist.objects.filter(user=request.user)
        data["playlists"] = playlists
    
    return render(request, "songs/playlist_songs.html", data)

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


def remove_song_from_a_playlist(request):
    if request.method == "POST":
        song_id = request.POST["song_id"]
        playlist_id = request.POST["playlist_id"]

        playlist = Playlist.objects.get(id=playlist_id)
        song = Song.objects.get(id=song_id)
        playlist.song.remove(song)

        data = {"message": song.title + " was removed from playlist " + playlist.name, "song": song.title, "playlist": playlist.name}
        return JsonResponse(data)

def delete_playlist(request):
    if request.method == "POST":
        playlist_id = request.POST["playlist_id"]

        Playlist.objects.filter(id=playlist_id).delete()
        data = {"message": "Playlist with ID" + str(playlist_id) + " was removed."}
        return JsonResponse(data)

def rename_playlist(request):
    if request.method == "POST":
        playlist_id = request.POST["playlist_id"]
        new_name = request.POST["new_name"]

        playlist = Playlist.objects.get(id=playlist_id)
        playlist.name = new_name
        playlist.save()

        data = {"message": "Playlist with ID" + str(playlist_id) + " was successfully renamed to " + new_name + "."}
        return JsonResponse(data)