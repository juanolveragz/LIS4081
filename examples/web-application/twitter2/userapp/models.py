from django.db import models
from django.contrib.auth.models import User

# Create your models here.


class Message(models.Model):
    message_text = models.CharField(max_length=140)
    pub_date = models.DateTimeField('date published')
    edit_date = models.DateTimeField('date modified')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
