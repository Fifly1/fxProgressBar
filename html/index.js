let intervalId;
let currentBox = 0;

window.addEventListener('message', function(event) {
    if (event.data.action === "show") {
        clearInterval(intervalId);
        currentBox = 0;
        document.body.innerHTML = `
        <div id="progress-bar" style="display:none;">
            <div class="progress-header">
                <p id="label">Loading...</p>
                <p id="percentage">0%</p>
            </div>
            <div class="progress-container">
                <div class="progress-box" id="box1"></div>
                <div class="progress-box" id="box2"></div>
                <div class="progress-box" id="box3"></div>
                <div class="progress-box" id="box4"></div>
                <div class="progress-box" id="box5"></div>
                <div class="progress-box" id="box6"></div>
                <div class="progress-box" id="box7"></div>
                <div class="progress-box" id="box8"></div>
                <div class="progress-box" id="box9"></div>
                <div class="progress-box" id="box10"></div>
                <div class="progress-box" id="box11"></div>
                <div class="progress-box" id="box12"></div>
                <div class="progress-box" id="box13"></div>
                <div class="progress-box" id="box14"></div>
                <div class="progress-box" id="box15"></div>
            </div>
        </div>
        `;
        
        const progressBar = document.getElementById('progress-bar');
        const label = document.getElementById('label');
        const percentage = document.getElementById('percentage');
        progressBar.style.display = "block";
        setTimeout(() => progressBar.style.opacity = "1", 10);
        label.innerText = event.data.label;
        let duration = event.data.duration;
        let interval = duration / 15;

        intervalId = setInterval(() => {
            if (currentBox >= 15) {
                clearInterval(intervalId);
                percentage.innerText = '100%';
            } else {
                currentBox++;
                document.getElementById(`box${currentBox}`).classList.add('filled');
                percentage.innerText = `${Math.round((currentBox / 15) * 100)}%`;
            }
        }, interval);
    } else if (event.data.action === "hide") {
        const progressBar = document.getElementById('progress-bar');
        if (progressBar) {
            progressBar.style.opacity = "0";
            setTimeout(() => {
                clearInterval(intervalId);
                intervalId = null;
                document.body.innerHTML = "";
            }, 500);
        }
    }
});
