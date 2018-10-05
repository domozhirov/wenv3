(function() {
    class HTTP {
        static async _fetch(url, method, body, timeout = 400) {
            let params = {
                method: method,
                credentials: "same-origin",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                timeout: timeout
            };

            if (body) {
                params.body = body;
            }

            return fetch(url, params)
                .then(response => {
                    if (response.status >= 200 && response.status < 300) {
                        return Promise.resolve(response);
                    } else {
                        return Promise.reject(new Error(response.statusText));
                    }
                })
                .then(response => {
                    return response.json();
                });
        };

        static async get(url, body = "") {
            return this._fetch(url, "GET", body);
        }

        static async post(url, body) {
            return this._fetch(url, "POST", body);
        }
    }

    const form = document.querySelector('form');

    form.addEventListener('submit', event => {
        let body = [];

        for (let element of form.elements) {
            switch (element.name) {
                case 'port':
                case 'live':
                case 'socketPort':
                    body.push(`${element.name}=${~~element.value}`);
                    break;
                case 'projectDir':
                    body.push(`${element.name}=${element.value}`);
                    break;
            }
        }

        HTTP.post('/settings', body.join('&')).then(response => {
            if (response.result === 'saved') {
                document.querySelector('.alert').removeAttribute('hidden');
            }
        });

        event.preventDefault();
    })
})();
