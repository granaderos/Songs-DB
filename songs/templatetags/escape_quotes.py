from django import template

register = template.Library()

@register.filter
def escape_quotes(value):
    value = str(value)
    value = value.replace("\"", "&quot;")
    return value.replace("'","&#39;")