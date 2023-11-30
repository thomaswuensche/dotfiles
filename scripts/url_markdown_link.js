function run(input, parameters) {
    const systemEvents = Application("System Events");
    const frontProcess = systemEvents.processes.whose({ frontmost: true })[0];
    const appName = frontProcess.displayedName();
    const app = Application.currentApplication();
    app.includeStandardAdditions = true;

    let url = undefined;
    let title = undefined;
    let hostname = undefined;

    const activeWindow = Application(appName).windows[0];
    const activeTab = activeWindow.activeTab();

    url = activeTab.url();
    title = activeTab.name();

    const matches = url.match(/^https?\:\/\/([^\/?#]+)(?:[\/?#]|$)/i);
    hostname = matches && matches[1];

    if (title === undefined && url === undefined) {
        console.log("could not copy url or title");
    } else {
        app.setTheClipboardTo(`[${hostname} - ${title}](${url})`);
    }
	return input;
}
