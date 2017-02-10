require 'imget'

describe '.httpify' do
  context 'when httpified url' do
    it 'returns unchanged url' do
      imget = Imget.new('http://example.com')
      expect(imget.httpify('http://example.com')).to eq 'http://example.com'
    end
  end

  context 'when httpsified url' do
    it 'returns unchanged url' do
      imget = Imget.new('https://example.com')
      expect(imget.httpify('https://example.com')).to eq 'https://example.com'
    end
  end

  context 'when raw url' do
    it 'returns httpified url' do
      imget = Imget.new('example.com')
      expect(imget.httpify('example.com')).to eq 'http://example.com'
    end
  end
end

describe '.image_address' do
  context 'with scheme-relative url' do
    it 'returns http://image_address' do
      imget = Imget.new('http://example.com')
      expect(imget.image_address('//imgur.com/i.jpg')).to eq 'http://imgur.com/i.jpg'
    end

    it 'returns https://image_address' do
      imget = Imget.new('https://example.com')
      expect(imget.image_address('//imgur.com/i.jpg')).to eq 'https://imgur.com/i.jpg'
    end
  end

  context 'with root-relative url' do
    it 'returns http://image_address' do
      imget = Imget.new('http://example.com')
      expect(imget.image_address('/i.jpg')).to eq 'http://example.com/i.jpg'
    end

    it 'returns https://image_address' do
      imget = Imget.new('https://example.com')
      expect(imget.image_address('/i.jpg')).to eq 'https://example.com/i.jpg'
    end
  end

  context 'with absolute url' do
    it 'returns unchanged image address' do
      imget = Imget.new('http://example.com')
      expect(imget.image_address('https://imgur.com/i.jpg')).to eq 'https://imgur.com/i.jpg'
    end
  end
end

describe '.get_images' do
  context 'when webpage has no images' do
    it 'returns empty array' do
      imget = Imget.new('http://example.com')
      allow(imget).to receive(:request_url) { '<html></html>' }
      expect(imget.get_images).to match_array([])
    end
  end

  context 'when webpage has images' do
    it 'returns non-empty array' do
      imget = Imget.new('http://example.com')
      allow(imget).to receive(:request_url) { '<html><body><img src="/i.jpg"></body></html>' }
      expect(imget.get_images).to match_array(['http://example.com/i.jpg'])
    end
  end
end
