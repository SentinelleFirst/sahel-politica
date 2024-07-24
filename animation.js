document.addEventListener("DOMContentLoaded", function () {
    const observerOptions = {
        root: null,
        rootMargin: "0px",
        threshold: 0.1 // Trigger when 10% of the element is visible
    };

    const observerCallback = (entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target); // Optional: Stop observing once the animation is triggered
            }
        });
    };

    const observer = new IntersectionObserver(observerCallback, observerOptions);

    // Select the elements to observe
    const targets = document.querySelectorAll('.services-menu-box, .service-intro div, .service-intro img');
    targets.forEach(target => observer.observe(target));
});
