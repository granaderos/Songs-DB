from django.contrib import admin
from . models import Artist
from . models import Genre
from . models import Album
from . models import Song
from . models import Playlist



# Register your models here.
admin.site.register(Artist)
admin.site.register(Genre)
admin.site.register(Album)
admin.site.register(Song)
admin.site.register(Playlist)


