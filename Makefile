.PHONY: proxy tidy fmt lint pre-commit

proxy:
	@go env -w GO111MODULE="on"
	@go env -w GOPROXY="https://goproxy.cn,direct"
	@go env -w GOPRIVATE="github.com/timerlau/goctl-swagger"
	@git config --global url."git@github.com:timerlau/goctl-swagger.git".insteadOf "https://github.com/timerlau/goctl-swagger.git"

tidy:
	@go mod tidy -e -v

fmt:
	@find . -name '*.go' -not -path "./example/*" | xargs gofumpt -w -extra
	@find . -name '*.go' -not -path "./example/*" | xargs -n 1 -t goimports-reviser -rm-unused -set-alias -company-prefixes "github.com/timerlau" -project-name "github.com/timerlau/goctl-swagger"
	@find . -name '*.sh' -not -path "./example/*" | xargs shfmt -w -s -i 2 -ci -bn -sr

lint:
	@golangci-lint run ./...

pre-commit: tidy fmt lint
