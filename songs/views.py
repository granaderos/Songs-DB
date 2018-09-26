from django.shortcuts import render
from django.http import HttpResponse
from django.utils.encoding import smart_str

from . models import Genre
from . models import Artist
from . models import Album
from . models import Song
from . models import Playlist

def index(request):

    genres = Genre.objects.all()
    return render(request, "songs/index.html", context={"genres": genres})

def list_songs_based_on_genre(request, genre_id):
    genre = Genre.objects.get(id=genre_id)
    songs = Song.objects.filter(genre_id=genre_id)
    return render(request, "songs/genre_songs.html", context={"songs": songs, "genre": genre})

def search_song(request):
    search_filter = request.GET["search_filter"]
    search_keyword = request.GET["search_keyword"]

    songs = Song.objects.filter(title__contains=search_keyword)

    return render(request, "songs/search_songs.html", context={"songs": songs, "search_filter": search_filter, "search_keyword": search_keyword})

def download_song(request):
    path = request.GET["path"]
    with open(path, 'rb') as mp3:
        response = HttpResponse(mp3, content_type="audio/mpeg") 
        # without the below line, the browser will play it.
        response["Content-disposition"] = "attachment; filename=%s" % smart_str(path)
        
        return response