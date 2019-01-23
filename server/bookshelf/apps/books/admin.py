from django.contrib import admin

from .models import Book


class BookAdmin(admin.ModelAdmin):
    list_display = ("title", "isbn", "published_at")


admin.site.register(Book, BookAdmin)
