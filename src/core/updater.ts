import * as got from 'got';
import * as os from "os";
import * as semver from 'semver';

const { autoUpdater } = require('electron');

class Updater {
    private _repo: string = 'domozhirov/wenv';

    private _repoUrl: string;

    private _currentVersion: string;

    private _platform: string;

    private _autoUpdater;

    constructor() {
        this._repoUrl = 'https://github.com/' + this._repo;
        this._currentVersion = require('../package.json').version;
        this._platform = `${os.platform()}_${os.arch()}`;
        this._autoUpdater = autoUpdater;
    }

    _getLatestTag() {
        let url = this._repoUrl + '/releases/latest';

        return got.head(url)
            .then(res => {
                return res.socket['_httpMessage'].path.split('/').pop();
            })
            .catch(err => {
                if (err) throw new Error('Unable to get latest release tag from Github.')
            })
    }

    _getCurrentVersion() {
        return this._currentVersion
    }

    _newVersion(latest) {
        return semver.lt(this._getCurrentVersion(), latest)
    }

    _getFeedUrl(tag) {
        let feedUrl;

        if (process.platform !== 'darwin') {
            return new Promise((resolve, reject) => {
                feedUrl = this._repoUrl + '/releases/download/' + tag;
                resolve(feedUrl)
            })
        }

        // On Mac we need to use the `auto_updater.json`
        feedUrl = 'https://raw.githubusercontent.com/' + this._repo + '/master/auto_updater.json';

        // Make sure feedUrl exists
        return got.get(feedUrl)
            .then(res => {
                if (res.statusCode === 404) {
                    throw new Error('auto_updater.json does not exist.')
                } else if (res.statusCode !== 200) {
                    throw new Error('Unable to fetch auto_updater.json: ' + res.body)
                }

                let zipUrl;

                try {
                    zipUrl = JSON.parse(res.body).url
                } catch (err) {
                    throw new Error('Unable to parse the auto_updater.json: ' + err.message + ', body: ' + res.body)
                }

                const matchReleaseUrl = zipUrl.match(/\/(v)?(\d+\.\d+\.\d+)\/.*\.zip/);

                if (!matchReleaseUrl) {
                    throw new Error('The zipUrl (' + zipUrl + ') is a invalid release URL')
                }

                const versionInZipUrl = matchReleaseUrl[matchReleaseUrl.length - 1];
                const latestVersion = semver.clean(tag);

                if (versionInZipUrl !== latestVersion) {
                    throw new Error('The feedUrl does not link to latest tag (zipUrl=' + versionInZipUrl + '; latestVersion=' + latestVersion + ')')
                }

                return {
                    url: feedUrl
                }
            })
    }

    async check() {
        return new Promise((resolve, reject) => {
            this._getLatestTag()
                .then(res => {
                    const tag = semver.clean(res);

                    if (!tag || !semver.valid(tag)) {
                        throw new Error('Could not find a valid release tag.')
                    }

                    if (!this._newVersion(tag)) {
                        throw new Error('There is no newer version.')
                    }

                    return this._getFeedUrl(tag);
                })
                .then(feedUrl => {
                    // if (!'darwin' && !'win32') return reject(new Error('This platform is not supported.'));
                    // Set feedUrl in auto_updater.
                    console.log(feedUrl);
                    this._autoUpdater.setFeedURL(feedUrl);

                    resolve(true);
                })
                .catch(err => {
                    reject(err || null)
                })
        })
    }

    download() {
        this._autoUpdater.checkForUpdates();
    }

    install() {
        this._autoUpdater.quitAndInstall();
    }
}

export default Updater;
