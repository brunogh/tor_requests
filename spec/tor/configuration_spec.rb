# frozen_string_literal: true

require "spec_helper"

describe Tor::Configuration do
  subject(:configuration) { described_class.new }

  it "has default port" do
    expect(configuration.port).to eq(9050)
  end

  it "has default headers" do
    expect(configuration.headers).to eq({})
  end

  it "has default ip" do
    expect(configuration.ip).to eq("127.0.0.1")
  end

  describe "initialize" do
    it "has default headers" do
      configuration.add_header("User-Agent", "Netscape 2.0")

      expect(configuration.headers).to eq({ "User-Agent" => "Netscape 2.0" })
    end

    it "has default port" do
      configuration.port = 99

      expect(configuration.port).to eq(99)
    end

    it "has default ip" do
      configuration.ip = "whatever"

      expect(configuration.ip).to eq("whatever")
    end
  end
end
