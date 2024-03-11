.PHONY: strings
strings:
	@python3 SwiftUISample/Scripts/strings.py

.PHONY: test
test:
	@xcodebuild \
		-project SwiftUISample.xcodeproj \
		-scheme SwiftUISample \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		test