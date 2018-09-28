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
    return render(request, "songs/genre_songs.html", context={"songs": songs, "genre": genre})

def search_song(request):
    search_filter = request.GET["search_filter"]
    search_keyword = request.GET["search_keyword"]

    #songs = Song.objects.filter(search_filter__icontains=search_keyword)

    songs = None

    if search_filter == "title":
        songs = Song.objects.filter(title__icontains=search_keyword)
    elif search_filter == "genre":
        songs = Song.objects.filter(genre__genre__icontains=search_keyword)
    elif search_filter == "album":
        songs = Song.objects.filter(album__title__icontains=search_keyword)
    else:
        songs = Song.objects.filter(album__artist__name__icontains=search_keyword)

    return render(request, "songs/search_songs.html", context={"songs": songs, "search_filter": search_filter, "search_keyword": search_keyword})

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

            data = {"message": "New playlist was successfully created.", "user": user.username}
            return JsonResponse(data)
