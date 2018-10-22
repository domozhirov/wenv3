(function () {
    class HTTP {
        static async _fetch(url, method, body, timeout = 400) {
            let params = {
                method: method,
                credentials: "same-origin",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
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
        const section = form.dataset.section;
        let data = {};
        let value;

        if (!section) return;

        for (let element of form.elements) {
            if (!element.value) continue;

            switch (element.type) {
                case 'number':
                    value = ~~element.value;
                    break;
                case 'checkbox':
                case 'radio':
                    value = element.value === '1';
                    break;
                default:
                    value = element.value;
            }

            data[element.name] = value;
        }

        HTTP.post('/settings', `section=${section}&data=${JSON.stringify(data)}`).then(response => {
            if (response.result === 'saved') {
                document.querySelector('.alert').removeAttribute('hidden');
            }
        });

        event.preventDefault();
    });
})();


//
// const data = new FormData;
// let value;
//
// for (let element of form.elements) {
//     if (!element.value) continue;
//
//     switch (element.type) {
//         case 'number':
//             value = ~~element.value;
//             break;
//         case 'checkbox':
//         case 'radio':
//             value = element.value === '1';
//             break;
//         default:
//             value = element.value;
//     }
//
//     data.set(element.name, value);
// }
// console.log(data);

// HTTP.post('/settings', `data=${JSON.stringify(body)}`).then(response => {
//     if (response.result === 'saved') {
//         document.querySelector('.alert').removeAttribute('hidden');
//     }
// });


// var data = new URLSearchParams();
// let value;
//
// for (let element of form.elements) {
//     if (!element.value) continue;
//
//     switch (element.type) {
//         case 'number':
//             value = ~~element.value;
//             break;
//         case 'checkbox':
//         case 'radio':
//             value = element.value === '1';
//             break;
//         default:
//             value = element.value;
//     }
//
//     // body.push(`${element.name}=${value}`)
//     data.append(element.name, value);