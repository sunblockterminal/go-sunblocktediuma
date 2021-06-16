# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gsbt android ios gsbt-cross evm all test clean
.PHONY: gsbt-linux gsbt-linux-386 gsbt-linux-amd64 gsbt-linux-mips64 gsbt-linux-mips64le
.PHONY: gsbt-linux-arm gsbt-linux-arm-5 gsbt-linux-arm-6 gsbt-linux-arm-7 gsbt-linux-arm64
.PHONY: gsbt-darwin gsbt-darwin-386 gsbt-darwin-amd64
.PHONY: gsbt-windows gsbt-windows-386 gsbt-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gsbt:
	build/env.sh go run build/ci.go install ./cmd/gsbt
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gsbt\" to launch gsbt."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gsbt.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gsbt.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

gsbt-cross: gsbt-linux gsbt-darwin gsbt-windows gsbt-android gsbt-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-*

gsbt-linux: gsbt-linux-386 gsbt-linux-amd64 gsbt-linux-arm gsbt-linux-mips64 gsbt-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-*

gsbt-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gsbt
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep 386

gsbt-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gsbt
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep amd64

gsbt-linux-arm: gsbt-linux-arm-5 gsbt-linux-arm-6 gsbt-linux-arm-7 gsbt-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep arm

gsbt-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gsbt
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep arm-5

gsbt-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gsbt
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep arm-6

gsbt-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gsbt
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep arm-7

gsbt-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gsbt
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep arm64

gsbt-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gsbt
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep mips

gsbt-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gsbt
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep mipsle

gsbt-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gsbt
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep mips64

gsbt-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gsbt
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-linux-* | grep mips64le

gsbt-darwin: gsbt-darwin-386 gsbt-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-darwin-*

gsbt-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gsbt
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-darwin-* | grep 386

gsbt-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gsbt
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-darwin-* | grep amd64

gsbt-windows: gsbt-windows-386 gsbt-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-windows-*

gsbt-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gsbt
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-windows-* | grep 386

gsbt-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gsbt
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gsbt-windows-* | grep amd64
