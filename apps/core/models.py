from re import A
from django.db import models

app_name = 'core'
# Create your models here.
class Element(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()

    def __str__(self):
        return self.name