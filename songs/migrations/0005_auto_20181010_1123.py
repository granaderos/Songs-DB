# Generated by Django 2.0.6 on 2018-10-10 03:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('songs', '0004_auto_20181009_1444'),
    ]

    operations = [
        migrations.AddField(
            model_name='album',
            name='cover',
            field=models.FileField(default='', upload_to='file/images/'),
        ),
        migrations.AlterField(
            model_name='song',
            name='path',
            field=models.FileField(default='', upload_to='file/audios/'),
        ),
    ]
