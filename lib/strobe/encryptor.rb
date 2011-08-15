module Strobe
  class Encryptor
    class InvalidMessage < StandardError; end
    OpenSSLCipherError = OpenSSL::Cipher.const_defined?(:CipherError) ? OpenSSL::Cipher::CipherError : OpenSSL::CipherError

    include Singleton

    class << self
      delegate :encrypt, :decrypt, :to => :instance
    end

    class_attribute :addon_secret

    def encrypt(msg, initvec = nil)
      msg       = msg.to_s
      cipher    = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
      initvec   = decode64(initvec) if initvec
      initvec ||= cipher.random_iv

      cipher.encrypt
      cipher.key = decode64(addon_secret)
      cipher.iv  = initvec

      encrypted  = cipher.update(msg)
      encrypted << cipher.final

      [ encrypted, initvec ].
        map { |bytes| encode64(bytes) }.
        join("--")
    end

    def decrypt(encrypted_message)
      cipher = new_cipher
      encrypted_data, iv = encrypted_message.split("--").map { |v| decode64(v) }

      cipher.decrypt
      cipher.key = decode64(addon_secret)
      cipher.iv  = iv

      decrypted_data = cipher.update(encrypted_data)
      decrypted_data << cipher.final

      decrypted_data
    rescue OpenSSLCipherError, TypeError
      raise InvalidMessage
    end

    private

    def decode64(s)
      ActiveSupport::Base64.decode64(s)
    end

    def encode64(s)
      ActiveSupport::Base64.encode64(s)
    end

    def new_cipher
      OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    end
  end
end