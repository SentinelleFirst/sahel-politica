document.addEventListener("DOMContentLoaded", function () {
    let carousel = document.querySelector(".carousel");
    let items = carousel.querySelectorAll(".item");
    let dotsContainer = document.querySelector(".dots");
    let currentIndex = 0;
    const intervalTime = 5000; // Time in milliseconds for each slide

    // Insert dots into the DOM
    items.forEach((_, index) => {
        let dot = document.createElement("span");
        dot.classList.add("dot");
        if (index === 0) dot.classList.add("active");
        dot.dataset.index = index;
        dotsContainer.appendChild(dot);
    });

    let dots = document.querySelectorAll(".dot");

    // Function to show a specific item
    function showItem(index) {
        items.forEach((item, idx) => {
            if (idx === index) {
                item.classList.add("active");
                dots[idx].classList.add("active");
            } else {
                item.classList.remove("active");
                dots[idx].classList.remove("active");
            }
        });
        currentIndex = index;
    }

    // Function to show the next item
    function showNextItem() {
        let nextIndex = (currentIndex + 1) % items.length;
        showItem(nextIndex);
    }

    // Event listeners for dots
    dots.forEach((dot) => {
        dot.addEventListener("click", () => {
            let index = parseInt(dot.dataset.index);
            showItem(index);
        });
    });

    // Automatically change slides at the set interval
    setInterval(showNextItem, intervalTime);
});
