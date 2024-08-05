window.addEventListener('message', function(event) {
    const progressBar = document.getElementById('progress-bar');
    const label = document.getElementById('label');
    const percentage = document.getElementById('percentage');
    
    if (event.data.action === "show") {
        progressBar.style.display = "block";
        setTimeout(() => progressBar.style.opacity = "1", 10);
        label.innerText = event.data.label;

        let duration = event.data.duration;
        let interval = duration / 15;

        let currentBox = 0;
        let id = setInterval(frame, interval);

        function frame() {
            if (currentBox >= 15) {
                clearInterval(id);
                percentage.innerText = '100%';
            } else {
                currentBox++;
                document.getElementById(`box${currentBox}`).classList.add('filled');
                percentage.innerText = `${Math.round((currentBox / 15) * 100)}%`;
            }
        }
    } else if (event.data.action === "hide") {
        progressBar.style.opacity = "0";
        setTimeout(() => {
            progressBar.style.display = "none";
            percentage.innerText = '0%';
            for (let i = 1; i <= 15; i++) {
                document.getElementById(`box${i}`).classList.remove('filled');
            }
        }, 500);
    }
});
