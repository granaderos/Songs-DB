from django.urls import path
from . import views


urlpatterns = [
    path('', views.index, name='index'),
    path("songs/genre/<int:genre_id>", views.list_songs_based_on_genre, name="genre"),
    path("search/", views.search_song, name="search_song"),
    path("download/", views.download_song, name="download_song"),
    path("song/<int:song_id>", views.play_song, name="play_song"),
    path("playlist/", views.display_playlist, name="display_playlist"),
    path("playlist/add/", views.add_playlist, name="add_playlist"),
    path("playlist/<int:playlist_id>/songs", views.playlist_songs, name="playlist_songs"),
    path("playlist/song/add/", views.add_song_to_a_playlist, name="add_song_to_a_playlist"),
    path("playlist/song/remove/", views.remove_song_from_a_playlist, name="remove_song_from_a_playlist"),
    path("playlist/delete/", views.delete_playlist, name="delete_playlist"),
    path("playlist/rename/", views.rename_playlist, name="rename_playlist"),
    
    # admin urls
    path('data_man/login', views.data_man_landing, name='data_man_landing'),
    path('data_man_login/', views.data_man_login, name='data_man_login'),
    path('data_man_logout/', views.data_man_logout, name='data_man_logout'),
    path('data_man/dashboard', views.data_man_dashboard, name='data_man_dashboard'),
    path('data_man/songs', views.data_man_songs, name='data_man_songs'),
    path("data_man/add_song/", views.add_song, name="add_song"),
    path("data_man/albums", views.data_man_albums, name="data_man_albums"),
    path("data_man/add_album/", views.add_album, name="add_album"),
    path("data_man/add_album_with_songs/", views.add_album_with_songs, name="add_album_with_songs"),
    path("data_man/artists", views.data_man_artists, name="data_man_artists"),
    path("data_man/add_artist/", views.add_artist, name="add_artist"),
    path("data_man/genres", views.data_man_genres, name="data_man_genres"),
    path("data_man/add_genre/", views.add_genre, name="add_genre"),

    path("data_man/search_song/", views.data_man_search_song, name="data_man_search_song"),
    path("data_man/search_artist/", views.data_man_search_artist, name="data_man_search_artist"),
    path("data_man/search_album/", views.data_man_search_album, name="data_man_search_album"),
    path("data_man/search_genre/", views.data_man_search_genre, name="data_man_search_genre"),

    path("data_man/delete_song/", views.data_man_delete_song, name="data_man_delete_song"),

    path("data_man/update_artist/", views.data_man_update_artist, name="data_man_update_artist"),
    path("data_man/delete_artist/", views.data_man_delete_artist, name="data_man_delete_artist"),

    path("data_man/update_album/", views.data_man_update_album, name="data_man_update_album"),
    path("data_man/delete_album/", views.data_man_delete_album, name="data_man_delete_album"),
    
    path("data_man/update_genre/", views.data_man_update_genre, name="data_man_update_genre"),
    path("data_man/delete_genre/", views.data_man_delete_genre, name="data_man_delete_genre"),

]