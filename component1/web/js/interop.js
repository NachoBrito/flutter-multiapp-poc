// Sets up a channel to JS-interop with Flutter
(function () {
    "use strict";
    let components = [
        { name: "WebComponent1", entrypointUrl: "http://localhost:8080/main.dart.js?r=" + Date.now() },
        { name: "WebComponent2", entrypointUrl: "http://localhost:8081/main.dart.js?r=" + Date.now() },
    ]

    let globalHandler = function (source, event) {
        console.log("Event received: " + event);
        window.dispatchEvent(new CustomEvent("flutterEvent", { detail: { flutterEvent: event, flutterSource: source } }));
    }

    let loadComponents = function () {
        for (let i = 0; i < components.length; i++) {
            let time = 300 * i;
            let componentName = components[i].name;
            let componentEntrypointUrl = components[i].entrypointUrl;
            setupEvents(componentName);

            setTimeout(function () {
                runComponent(componentName, componentEntrypointUrl);
            }, time);
        }
    }

    let setupEvents = function (componentName) {
        // This function will be called from Flutter when it prepares the JS-interop.
        window[componentName + "Home_initState"] = function () {
            window[componentName + "Home_initState"] = function () {
                console.log("Call _initState only once!");
            };
            let state = window[componentName + "Home_state"];
            state.addHandler((event) => {
                globalHandler(componentName, event);
            });
            window.addEventListener("flutterEvent", (e) => {
                if (e.detail.flutterSource != componentName) {
                    state.externalEvent(e.flutterEvent);
                }
            });
        }
    }

    let runComponent = function (componentName, componentEntrypointUrl) {
        let target = document.querySelector("#" + componentName);
        // console.log(target);
        _flutter.loader.loadEntrypoint({
            entrypointUrl: componentEntrypointUrl,
            serviceWorker: {
                serviceWorkerVersion: serviceWorkerVersion,
            },
            onEntrypointLoaded: function (engineInitializer) {
                console.info("** " + componentName + " LOADED **");
                engineInitializer.initializeEngine({ hostElement: target, }).then(function (appRunner) {
                    appRunner.runApp();
                });
            }
        });
    }

    window.addEventListener('load', loadComponents);
}());