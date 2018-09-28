from django.urls import path
from . import views


urlpatterns = [
    path('', views.index, name='index'),
    path("songs/genre/<int:genre_id>", views.list_songs_based_on_genre, name="genre"),
    path("search/", views.search_song, name="search_song"),
    path("download/", views.download_song, name="download_song"),
    path("song/<int:song_id>", views.play_song, name="play_song"),
    path("playlist/add/", views.add_playlist, name="add_playlist"),
    path("playlist/<int:playlist_id>/songs", views.playlist_songs, name="playlist_songs"),
    path("playlist/song/add/", views.add_song_to_a_playlist, name="add_song_to_a_playlist"),
    path("playlist/song/remove/", views.remove_song_from_a_playlist, name="remove_song_from_a_playlist"),
    path("playlist/delete/", views.delete_playlist, name="delete_playlist")
    
]