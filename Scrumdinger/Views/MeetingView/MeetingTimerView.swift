//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Mitul Vaghamshi on 2022-10-15.
//

import SwiftUI

struct MeetingTimerView: View {
    let speakers: [ScrumTimer.Speaker]
    let isRecording: Bool
    let theme: Theme
    
    private var currentSpeakker: String {
        speakers.first(where: { !$0.isCompleted })?.name ?? "Speaker X"
    }
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24, antialiased: true)
            .overlay {
                VStack {
                    Text(currentSpeakker)
                        .font(.title)
                    Text("is speaking")
                    Image(systemName: isRecording ? "mic" : "mic.slash")
                        .font(.title)
                        .padding(.top)
                        .accessibilityLabel(
                            isRecording
                            ? "with transcription"
                            : "without transcription")
                }
                .accessibilityElement(children: .combine)
                .foregroundStyle(theme.accentColor)
            }
            .overlay {
                ForEach(speakers) { speaker in
                    if speaker.isCompleted, let index = speakers.firstIndex(where: {
                        $0.id == speaker.id
                    }) {
                        SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                            .rotation(Angle(degrees: -90.0))
                            .stroke(theme.mainColor, lineWidth: 12)
                    }
                }
            }
            .padding(.horizontal)
    }
}

struct MeetingTimerView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingTimerView(speakers: DailyScrum.sampleData[0].attendees.map {
            ScrumTimer.Speaker(name: $0.name, isCompleted: false)
        }, isRecording: false, theme: .lavender)
    }
}
