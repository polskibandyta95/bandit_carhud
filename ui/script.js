window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.type === 'updateSpeedometer') {
        if (data.isDriver) {
            document.getElementById('hud-container').style.display = 'block';
        } else {
            document.getElementById('hud-container').style.display = 'none';
        }

        document.getElementById('gear').textContent = data.gear;

        const speedElement = document.getElementById('speed');
        const speedValue = Math.floor(data.speed).toString().padStart(3, '0');

        speedElement.innerHTML = '';

        const digits = speedValue.split('');
        digits.forEach((digit, index) => {
            const digitElement = document.createElement('span');
            digitElement.textContent = digit;
            digitElement.className = 'digit';
            speedElement.appendChild(digitElement);
        });

        const speedNumber = Math.floor(data.speed);

        Array.from(speedElement.children).forEach((digit, index) => {
            if (speedNumber < 10) {
                digit.style.opacity = index === 2 ? '1' : '0.3';
            } else if (speedNumber < 100) {
                digit.style.opacity = index >= 1 ? '1' : '0.3';
            } else {
                digit.style.opacity = '1';
            }
        });

        speedElement.classList.add('transition-opacity');
        setTimeout(() => {
            speedElement.classList.remove('transition-opacity');
        }, 500);

        let totalBars = 16;
        let activeBars = Math.floor(data.rpm / data.maxRpm * totalBars);

        for (let i = 1; i <= totalBars; i++) {
            const barElement = document.getElementById('bar' + i);
            if (i <= activeBars) {
                barElement.classList.remove('grey', 'szare');
                barElement.classList.add('purple');
            } else {
                barElement.classList.remove('purple');
                barElement.classList.add('grey', 'szare');
            }
        }

        let fuelPercentage = Math.max(0, data.fuel);
        document.querySelector('#fuel-gauge .circle').style.strokeDasharray = `${fuelPercentage}, 100`;

        let enginePercentage = Math.max(0, data.engineHealth / 10);
        document.querySelector('#engine-gauge .circle').style.strokeDasharray = `${enginePercentage}, 100`;

        let doorsIcon = document.getElementById('doors-icon');
        let seatbeltIcon = document.getElementById('seatbelt-icon');

        if (data.doorsOpen) {
            doorsIcon.classList.remove('active');
        } else {
            doorsIcon.classList.add('active');
        }

        if (data.seatbeltOn) {
            seatbeltIcon.classList.add('active');
        } else {
            seatbeltIcon.classList.remove('active');
        }

    }

    if (data.type === 'hideSpeedometer') {
        document.getElementById('hud-container').style.display = 'none';
    }
});
