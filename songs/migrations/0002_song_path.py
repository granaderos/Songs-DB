# Generated by Django 2.0.6 on 2018-09-25 09:26

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('songs', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='song',
            name='path',
            field=models.FileField(default='', upload_to='mp3_files/'),
        ),
    ]
