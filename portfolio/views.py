from django.shortcuts import render

def index(request):
    return render(request, 'portfolio/index.html')

def cv(request):
    return render(request, 'portfolio/cv.html')

def about(request):
    return render(request, 'portfolio/about.html')
