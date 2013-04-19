module Otp
	class Totp
		def gen_otps(seed, minutes)
	    v = []
	    now = Time.now.to_i
	      (2 * minutes + 1).times.each do |i|
	        hmac = OpenSSL::HMAC.digest(
	          OpenSSL::Digest::Digest.new('sha1'),
	          int_to_bytestring(seed),
	          int_to_bytestring((now + 60 * (i - minutes)) / 60)
	        )
	        offset = hmac[19].ord & 0xf
	        code = (hmac[offset].ord & 0x7f) << 24 |
	        (hmac[offset + 1].ord & 0xff) << 16 |
	        (hmac[offset + 2].ord & 0xff) << 8 |
	        (hmac[offset + 3].ord & 0xff)
	        v << (code % 10 ** 6)
	      end
	    v
	  end

	  def int_to_bytestring(int, padding = 8)
	    result = []
	    until int == 0
	      result << (int & 0xFF).chr
	      int >>=  8
	    end
	    result.reverse.join.rjust(padding, 0.chr)
	  end
	end
end