
document.addEventListener('DOMContentLoaded', function() {
    /*-------------------------SLIDER IMMAGINI-------------------------------*/ 
    const slider = document.querySelector('.slider');
    let currentIndex = 0;
    const slides = document.querySelectorAll('.slider img');
    const totalSlides = slides.length;

    function autoScroll() {
        console.log("Scrolling to slide: " + currentIndex);
        currentIndex = (currentIndex + 1) % totalSlides;
        slider.scrollTo({
            left: currentIndex * slider.clientWidth,
            behavior: 'smooth'
        });
    }
    setInterval(autoScroll, 4500);
});