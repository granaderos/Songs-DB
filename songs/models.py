from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Artist(models.Model):
    name = models.CharField(max_length=64)

    def __str__(self):
        return self.name


class Album(models.Model):
    title = models.CharField(max_length=64)

    def __str__(self):
        return self.title


class Genre(models.Model):
    genre = models.CharField(max_length=64)

    def __str__(self):
        return self.genre


class Song(models.Model):
    title = models.CharField(max_length=64)
    artist = models.ForeignKey(Artist, on_delete=models.CASCADE)
    album = models.ForeignKey(Album, on_delete=models.CASCADE)
    genre = models.ForeignKey(Genre, on_delete=models.CASCADE)

    def __str__(self):
        return self.title


class Playlist(models.Model):
    name = models.CharField(max_length=64)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    song = models.ManyToManyField(Song)

    def __str__(self):
        return self.name
