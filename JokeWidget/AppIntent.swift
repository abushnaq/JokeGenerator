//
//  AppIntent.swift
//  JokeWidget
//
//  Created by Ahmad Remote on 8/1/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("Time for a quick joke.")

    // An example configurable parameter.
    @Parameter(title: "Setup", default: "What's so funny?")
    var setup: String?
        
    @Parameter(title: "Punchline", default: "This joke!")
    var punchline: String?
}
