(function () {
    class HTTP {
        static async _fetch(url, options) {
            options = Object.assign({
                method: "GET",
                credentials: "same-origin",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                },
                timeout: 400
            }, options);

            return fetch(url, options)
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

        static async get(url, options) {
            return this._fetch(url, Object.assign({}, options, {
                method: "GET",
            }));
        }

        static async post(url, options) {
            return this._fetch(url, Object.assign({}, options, {
                method: "POST"
            }));
        }

        static async delete(url, options) {
            return this._fetch(url, Object.assign({}, options, {
                method: "DELETE"
            }));
        }

        static async put(url, options) {
            return this._fetch(url, Object.assign({}, options, {
                method: "PUT"
            }));
        }
    }

    class HTML {
        static parse(textHTML) {
            const tmp = document.implementation.createHTMLDocument();;

            tmp.body.innerHTML = textHTML;

            return tmp.body.children.length === 1 ? tmp.body.firstElementChild : [...tmp.body.children];
        }
    }

    const app = document.getElementById('list-app');

    app && app.addEventListener('submit', event => {
        const section = app.dataset.section;
        let data = {};
        let value;

        if (!section) return;

        for (let element of app.elements) {
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

        HTTP.post('/settings', {
            body: `section=${section}&data=${JSON.stringify(data)}`,
        }).then(response => {
            if (response.result === 'saved') {
                document.querySelector('.alert').removeAttribute('hidden');
            }
        });

        event.preventDefault();
    });

    const routes = document.getElementById('list-routes');

    routes && routes.addEventListener('submit', event => {
        const data = new FormData(routes);

        HTTP.post('/settings/install', {
            body: data,
            headers: {},
        }).then(response => {
            if (response.result) {
                const element = HTML.parse(`
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        ${response.result}
                        <button type="button" class="btn btn-danger" data-route="${response.result}">Delete</button>
                    </li>
                `);

                element.addEventListener('click', deleteRoute);

                routes.querySelector('ul').appendChild(element);
            }
        });

        event.preventDefault();
    });

    routes && [...routes.querySelectorAll('[data-route]')].forEach(item => {
        item.addEventListener('click', deleteRoute)
    });

    function deleteRoute(event) {
        const route = this.dataset.route;
        const listItem = this.parentNode;

        HTTP.post('/settings/route', {
            body: `route=${route}`,
        }).then(response => {
            if (response.result === 'deleted') {
                listItem.parentNode.removeChild(listItem);
            }
        });

        event.preventDefault();
    }
})();
