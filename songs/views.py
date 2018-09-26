from django.shortcuts import render
from . models import Genre
from . models import Artist
from . models import Album
from . models import Song
from . models import Playlist

def index(request):

    genres = Genre.objects.all()
    return render(request, "songs/index.html", context={"genres": genres})

