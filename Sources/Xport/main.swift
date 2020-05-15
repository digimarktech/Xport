#!/usr/bin/env swift
import ArgumentParser
import Foundation

// Define our parser.
struct Xport: ParsableCommand {
    // Declare expected launch argument(s).
    @Argument(help: "Specify your username.")
    var username: String
    
    @Argument(help: "Specify your hostname.")
    var hostname: String
    
    func run() throws {
        
        guard let pathURL = URL(string: FileManager.default.currentDirectoryPath) else {
            return
        }
        let destination = "~/Xport/\(pathURL.lastPathComponent)"
        
        print("-------------------------------")
        print("Configuration:")
        print("-------------------------------")
        print("Username: \(username)")
        print("Hostname: \(hostname)")
        print("Destination: \(destination)")
        print("-------------------------------")
        
        print("Getting ready to sync project to \(username)@\(hostname):\(destination)")
        
        /// Remote into Pi and create directory to copy files to
        let sshCommand = "ssh \(username)@\(hostname) mkdir -p \(destination)"
        let rsyncCommand = "rsync -azP --exclude=.build* --exclude=Packages/* --exclude=*.xcodeproj* --exclude=*.DS_Store* . \(username)@\(hostname):\(destination)"
        let remoteBuildCommand = "ssh \(username)@\(hostname) cd \(destination); swift build"
        
        let command1 = shell(sshCommand)
        print(command1.output)
        if command1.status == 0 {
            let command2 = shell(rsyncCommand)
            print(command2.output)
            if command2.status == 0 {
                print("Synced project to Raspberry Pi")
                print("Building the project")
                let command3 = shell(remoteBuildCommand)
                print(command3.output)
                if command3.status == 0 {
                    print("Successfully built project on your Raspberry Pi.")
                }
            }
        }
    }
    
    private func shell(_ command: String) -> ShellResult {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["-S", command]
        let pipe = Pipe()
        task.standardOutput = pipe
        let outputHandler = pipe.fileHandleForReading
        outputHandler.waitForDataInBackgroundAndNotify()

        var output = ""
        var dataObserver: NSObjectProtocol!
        let notificationCenter = NotificationCenter.default
        let dataNotificationName = NSNotification.Name.NSFileHandleDataAvailable
        dataObserver = notificationCenter.addObserver(forName: dataNotificationName, object: outputHandler, queue: nil) {  notification in
            let data = outputHandler.availableData
            guard data.count > 0 else {
                notificationCenter.removeObserver(dataObserver!)
                return
            }
            if let line = String(data: data, encoding: .utf8) {
                print(line)
                output = output + line + "\n"
            }
            outputHandler.waitForDataInBackgroundAndNotify()
        }

        task.launch()
        task.waitUntilExit()
        return ShellResult(output: output, status: task.terminationStatus)
    }
    
    struct ShellResult {

        let output: String
        let status: Int32

    }
}

// Run the parser.
Xport.main()
