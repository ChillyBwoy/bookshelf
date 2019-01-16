from django.db import models
from django.utils.translation import gettext as _

# Create your models here.


class Book(models.Model):
    isbn = models.CharField(_("isbn"), max_length=140, blank=True)
    title = models.CharField(_("title"), max_length=140)
    description = models.TextField(_("description"), blank=True)
    published_at = models.DateField(_("publish date"), blank=True, null=True)

    def __str__(self):
        return self.title

