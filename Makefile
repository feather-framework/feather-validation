build:
	swift build

release:
	swift build -c release
	
test:
	swift test --parallel

test-with-coverage:
	swift test --parallel --enable-code-coverage

clean:
	rm -rf .build

format:
	swift-format -i -r ./Sources && swift-format -i -r ./Tests

lint:
	swift-format lint -r ./Sources && swift-format lint -r ./Tests
