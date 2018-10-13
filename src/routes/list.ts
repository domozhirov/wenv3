import list from "../core/list";
import Settings from '../core/settings';

const settings = Settings.getInstance();

export = list(settings.projectDir);
