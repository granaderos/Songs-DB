from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Artist(models.Model):
    name = models.CharField(max_length=64, unique=True)

    def __str__(self):
        return self.name


class Album(models.Model):
    title = models.CharField(max_length=64)
    artist = models.ForeignKey(Artist, default="", on_delete=models.CASCADE)
    cover = models.FileField(upload_to="images/", default="")

    def __str__(self):
        return self.title


class Genre(models.Model):
    genre = models.CharField(max_length=64, unique=True)
    image = models.FileField(upload_to="images/", default="")

    def __str__(self):
        return self.genre


class Song(models.Model):
    title = models.CharField(max_length=64)
    album = models.ForeignKey(Album, on_delete=models.CASCADE)
    genre = models.ManyToManyField(Genre)
    size = models.FloatField(max_length=64, default=0.0)
    duration = models.FloatField(max_length=64, default=0.0)
    audio_format  = models.CharField(max_length=64, default="audio/mp3")
    path = models.FileField(upload_to="audios/", default="")

    def __str__(self):
        return self.title


class Playlist(models.Model):
    name = models.CharField(max_length=64)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    song = models.ManyToManyField(Song)

    def __str__(self):
        return self.name
