# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл тестирования класса `BitcoinCourseMonitoring::Tokens::Manager` менеджера токенов
# авторизации
#

RSpec.describe BitcoinCourseMonitoring::Tokens::Manager do
  subject 'the class' do
    subject { described_class }

    it { is_expected.not_to respond_to(:new) }
    functions = %i(instance register_key find_key_by_token!)
    it { is_expected.to respond_to(*functions) }
  end

  describe '.new' do
    subject { described_class.new }

    it 'should raise NoMethodError' do
      expect { subject }.to raise_error(NoMethodError)
    end
  end

  describe '.instance' do
    subject(:result) { described_class.instance }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }

      it 'should be always the same' do
        expect(result).to be == described_class.instance
      end

      it 'should be the only instance of the class' do
        subject
        expect(ObjectSpace.each_object(described_class) {}).to be == 1
      end
    end
  end

  describe '.register_key' do
    subject(:result) { described_class.register_key(key) }

    let(:key) { :key }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should return new value every time' do
        expect(subject).not_to be == described_class.register_key(key)
      end
    end

    it 'should register token' do
      token = subject
      expect(described_class.find_key_by_token!(token)).to be == key
    end
  end

  describe '.find_key_by_token!' do
    subject(:result) { described_class.find_key_by_token!(token) }

    let(:token) { described_class.register_key(key) }
    let(:key) { :key }

    describe 'result' do
      subject { result }

      it 'should be equal to registered key' do
        expect(subject).to be == key
      end
    end

    context 'when token isn\'t registered' do
      let(:token) { 'isn\'t registered' }

      it 'should raise RuntimeError' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end

    context 'when token is expired' do
      it 'should raise RuntimeError' do
        token = described_class.register_key(key)
        now = Time.now
        token_life_time = described_class.settings.token_life_time
        allow(Time).to receive(:now).and_return(now + token_life_time + 1)
        expect { described_class.find_key_by_token!(token) }
          .to raise_error(RuntimeError)
      end
    end
  end

  describe 'instance' do
    subject { described_class.instance }

    it { is_expected.to respond_to(:register_key, :find_key_by_token!) }
  end

  describe '#register_key' do
    subject(:result) { instance.register_key(key) }

    let(:instance) { described_class.instance }
    let(:key) { :key }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should return new value every time' do
        expect(subject).not_to be == instance.register_key(key)
      end
    end

    it 'should register token' do
      token = subject
      expect(instance.find_key_by_token!(token)).to be == key
    end
  end

  describe '#find_key_by_token!' do
    subject(:result) { instance.find_key_by_token!(token) }

    let(:instance) { described_class.instance }
    let(:token) { instance.register_key(key) }
    let(:key) { :key }

    describe 'result' do
      subject { result }

      it 'should be equal to registered key' do
        expect(subject).to be == key
      end
    end

    context 'when token isn\'t registered' do
      let(:token) { 'isn\'t registered' }

      it 'should raise RuntimeError' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end

    context 'when token is expired' do
      it 'should raise RuntimeError' do
        token = instance.register_key(key)
        now = Time.now
        token_life_time = described_class.settings.token_life_time
        allow(Time).to receive(:now).and_return(now + token_life_time + 1)
        expect { instance.find_key_by_token!(token) }
          .to raise_error(RuntimeError)
      end
    end
  end
end
