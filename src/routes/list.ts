import list from "../libs/list";
import Settings from '../libs/settings';

const settings = Settings.getInstance();

export default list(settings.projectDir);
