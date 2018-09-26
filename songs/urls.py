from django.urls import path
from . import views


urlpatterns = [
    path('', views.index, name='index'),
    path("songs/genre/<int:genre_id>", views.list_songs_based_on_genre, name="genre"),
    path("search/", views.search_song, name="search_song")
    
]