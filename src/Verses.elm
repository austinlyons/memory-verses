module Verses exposing ( versesCount, entryById, entryText, entryVerse, entryTranslation, entryCategory )

import Dict
import Maybe

-- verses to memorize
type alias Entry = { verse : String, text : String, translation : String, category: String }

versesList : List ( Int, Entry )
versesList =
  [ (0, Entry "Romans 3:23" "For all have sinned and fall short of the glory of God" "ESV" "salvation" )
  , (1, Entry "Romans 6:23" "the wages of sin is death, but the free gift of God is eternal life in Christ Jesus our Lord" "ESV" "salvation")
  , (2, Entry "Romans 5:8" "but God shows his love for us in that while we were still sinners, Christ died for us" "ESV" "salvation")
  , (3, Entry "Romans 10:9" "if you confess with your mouth that Jesus is Lord and believe in your heart that God raised him from the dead, you will be saved" "ESV" "salvation")
  , (4, Entry "Romans 8:1" "There is therefore now no condemnation for those who are in Christ Jesus" "ESV" "salvation")
  , (5, Entry "Deuteronomy 6:5" "Love the Lord your God with all your heart and with all your soul and with all your strength" "ESV" "commandments")
  , (6, Entry "Deuteronomy 6:6-7" "And these words that I command you today shall be on your heart. You shall teach them diligently to your children, and shall talk of them when you sit in your house, and when you walk by the way, and when you lie down, and when you rise" "ESV" "parenting")
  ]

-- look up table (integer indexed dictionary)
verses : Dict.Dict Int Entry
verses = Dict.fromList(versesList)

versesCount : Int
versesCount = List.length versesList

entryById : Int -> Maybe Entry
entryById idx =
  Dict.get idx verses

--- "getters"... seems like the compiler likes these, feels weird though, I think I'm missing something
entryText :  Maybe Entry -> String
entryText entry =
  case entry of
    Just entry -> entry.text
    Nothing -> ""

entryVerse :  Maybe Entry -> String
entryVerse entry =
  case entry of
    Just entry -> entry.verse
    Nothing -> ""

entryTranslation : Maybe Entry -> String
entryTranslation entry =
  case entry of
    Just entry -> entry.translation
    Nothing -> ""

entryCategory : Maybe Entry -> String
entryCategory entry =
  case entry of
    Just entry -> entry.category
    Nothing -> ""
