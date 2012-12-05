using GUdev;

int main(string[] args) {
    var loop = new MainLoop();
    if (args.length < 2) {
        stderr.printf("Usage: %s <handler script>\n",args[0]);
        return 1;
    }
    var handler = args[1];
    const string[] subsys = {};
    var gud = new Client(subsys);

    gud.uevent.connect((action, device) => {
        var sysfs_path = device.get_sysfs_path();
        var subsystem = device.get_subsystem();
        var devtype = device.get_devtype ();
        if (devtype==null) devtype="none";
        //stdout.printf("%s %s %s %s: \n",action,subsystem,devtype,sysfs_path);
        try {
            Process.spawn_async(null,
                { handler, action, subsystem, devtype, sysfs_path },
                Environ.get(),
                SpawnFlags.SEARCH_PATH,
                null,
                null);
        } catch (SpawnError e) {
            log("ueatadick", LogLevelFlags.LEVEL_WARNING, e.message);
        }
    });

    loop.run();
    return 0;
}
