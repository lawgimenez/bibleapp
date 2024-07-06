//
//  PassageView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI
import SwiftData
import Supabase

private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)

struct PassageView: View {

    @State private var highlightsColor = [
        Highlights(color: .highlightPink),
        Highlights(color: .highlightGreen),
        Highlights(color: .highlightGrayish),
        Highlights(color: .highlightLightBlue)
    ]

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var bibleObservable: BibleObservable
    @StateObject private var noteObservable = NoteObservable()
    @Query private var passage: [PassageData]
    @Query private var highlights: [Highlight]
    @State private var notes = [Note]()
    @Query private var bibles: [BibleData]
    @Query private var chapters: [ChapterData]
    @State private var selectedRange: NSRange?
    @State private var textHeight: CGFloat = 300
    @State private var passageAttributed = NSAttributedString(string: "")
    @State private var textStyle = UIFont.TextStyle.body
    @State private var arrayHighlights = [Highlight]()
    @State private var highlightAdded = false
    @State private var isPresentHighlightOptions = false
    @State private var isPresentAddNotesOptions = false
    @State private var selectedColor = Highlights(color: .highlightPink)
    @State private var addedHighlight = false
    @State private var highlight: Highlight?
    @State private var note: Note?
    var bibleId: String
    var chapterId: String

    init(bibleId: String, chapterId: String) {
        self.bibleId = bibleId
        self.chapterId = chapterId
        let predicate = #Predicate<PassageData> {
            $0.bibleId == bibleId && $0.chapterId == chapterId
        }
        _passage = Query(filter: predicate)
        let highlightPredicate = #Predicate<Highlight> {
            $0.bibleId == bibleId && $0.chapterId == chapterId
        }
        _highlights = Query(filter: highlightPredicate)
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextSelectable(text: passageAttributed, bibleId: bibleId, chapterId: chapterId)
            }
            .onChange(of: bibleObservable.passageContent) {
                if let passageData = passage.first {
                    let passageData = passageData.content.data(using: .unicode)
                    let attributedPassageData = try? NSAttributedString(data: passageData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                    passageAttributed = attributedPassageData!
                }
            }
            .onChange(of: noteObservable.addNoteStatus) {
                if noteObservable.addNoteStatus == .success {
                    if let notesFound = getNotesFromDatabase(modelContext: modelContext) {
                        notes = notesFound
                    }
                }
            }
            .onChange(of: passageAttributed) {
                passageAttributed = addNotesAndHighlights(text: passageAttributed.string)
            }
            .onChange(of: addedHighlight) {
                if addedHighlight {
                    if let highlight {
                        // Update highlight color value to one selected by user
                        highlight.color = selectedColor.color
                        highlight.bibleName = getBible(bibleId: highlight.bibleId) ?? ""
                        highlight.chapterName = getChapter(chapterId: highlight.chapterId) ?? ""
                        // Construct highlight encodable
                        let highlightEncodable = HighlighEncodable(passage: highlight.passage, color: highlight.uiColor.hexString, length: highlight.length, location: highlight.location, bibleId: highlight.bibleId, bibleName: highlight.bibleName, chapterId: highlight.chapterId, chapterName: highlight.chapterName, userUuid: UserDefaults.standard.string(forKey: User.Key.uuid.rawValue)!)
                        // Save to API
                        saveHighlightToApi(highlightEncodable: highlightEncodable)
                        do {
                            // Save to database
                            modelContext.insert(highlight)
                            try modelContext.save()
                        } catch {
                            print("Passage highlight data error: \(error)")
                        }
                        addedHighlight = false
                        isPresentHighlightOptions = false
                    }
                    passageAttributed = addNotesAndHighlights(text: passageAttributed.string)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("highlightAdded"))) { output in
                if let highlight = output.userInfo!["data"] as? Highlight {
                    self.highlight = highlight
                    isPresentHighlightOptions = true
                }
                passageAttributed = addNotesAndHighlights(text: passageAttributed.string)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("addNote"))) { output in
                if let note = output.userInfo!["data"] as? Note {
                    print("Note received: \(note)")
                    self.note = note
                }
            }
            .sheet(isPresented: $isPresentHighlightOptions) {
                HighlightOptionView(highlightsColor: $highlightsColor, selectedColor: $selectedColor, addedHighlight: $addedHighlight)
                    .presentationDetents([.height(300)])
            }
            .onChange(of: note) {
                if let note {
//                    note.color = selectedColor.color
                    note.bibleName = getBible(bibleId: note.bibleId) ?? ""
                    note.chapterName = getChapter(chapterId: note.chapterId) ?? ""
                    isPresentAddNotesOptions = true
                }
            }
            .sheet(isPresented: $isPresentAddNotesOptions) {
                if let note {
                    AddNotesView(isPresentAddNotesOptions: $isPresentAddNotesOptions, note: note)
                        .environmentObject(noteObservable)
                } else {
                    let _ = print("No notes")
                }
            }
            .background(Color.red)
            .navigationTitle("Passage")
            .padding(18)
            .task {
                do {
                    try await bibleObservable.getPassage(bibleId: bibleId, anyId: chapterId, modelContext: modelContext)
                } catch {
                    print(error)
                }
                if let passageData = passage.first {
                    let passageData = passageData.content.data(using: .unicode)
                    let attributedPassageData = try? NSAttributedString(data: passageData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                    passageAttributed = attributedPassageData!
                }
                if let notesFound = getNotesFromDatabase(modelContext: modelContext) {
                    notes = notesFound
                }
            }
        }
    }
    
    private func addNotesAndHighlights(text: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString.init(string: text)
        let attributedString = NSAttributedString(string: text)
        print("Notes found: \(notes.count)")
        for note in notes {
            // Create note image attachment
            let noteAttachment = NSTextAttachment()
            noteAttachment.image = UIImage(systemName: "note.text")
            let noteAttributedString = NSAttributedString(attachment: noteAttachment)
            // Get the highlight range
            let noteText = attributedString.attributedSubstring(from: note.getRange())
            let noteMutable = NSMutableAttributedString(attributedString: noteText)
            noteMutable.append(noteAttributedString)
            print("Note mutable = \(noteMutable)")
            mutableString.replaceCharacters(in: note.getRange(), with: noteMutable)
            // Add highlights for notes
            let highlightAttributes: [NSAttributedString.Key: Any] = [
                .backgroundColor: UIColor(Color(.highlightPink)),
                .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                .attachment: noteAttachment
            ]
            mutableString.addAttributes(highlightAttributes, range: note.getRange())
        }
        for highlight in highlights {
            // Add highlights
            let highlightAttributes: [NSAttributedString.Key: Any] = [
                .backgroundColor: highlight.uiColor,
                .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            ]
            mutableString.addAttributes(highlightAttributes, range: highlight.getRange())
        }
        return mutableString
    }

    private func getBible(bibleId: String) -> String? {
        let biblePredicate = #Predicate<BibleData> {
            $0.id == bibleId
        }
        let fetchDescriptor = FetchDescriptor(predicate: biblePredicate)
        do {
            if let bible = try modelContext.fetch(fetchDescriptor).first {
                return bible.name
            }
        } catch {
            print(error)
        }
        return nil
    }

    private func getChapter(chapterId: String) -> String? {
        let chapterPredicate = #Predicate<ChapterData> {
            $0.id == chapterId
        }
        let fetchDescriptor = FetchDescriptor(predicate: chapterPredicate)
        do {
            if let chapter = try modelContext.fetch(fetchDescriptor).first {
                return chapter.content
            }
        } catch {
            print(error)
        }
        return nil
    }

    private func saveHighlightToApi(highlightEncodable: HighlighEncodable) {
        // Save to API
        Task {
            do {
                try await client.from("Highlight").insert(highlightEncodable).execute()
            } catch {
                print("API Error: \(error)")
            }
        }
    }
    
    private func getNotesFromDatabase(modelContext: ModelContext) -> [Note]? {
        let notePredicate = #Predicate<Note> {
            $0.bibleId == bibleId && $0.chapterId == chapterId
        }
        let fetchDescriptor = FetchDescriptor(predicate: notePredicate)
        do {
            let notes = try modelContext.fetch(fetchDescriptor)
            return notes
        } catch {
            print("Books fetch error: \(error)")
            return nil
        }
    }
}

extension UIColor {

    var hexString: String {
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha

        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )

        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a * 255)))
        }

        return color
    }

    convenience init(hexString: String) {
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
}
