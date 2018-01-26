# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл тестирования модели учетной записи администротора
# `IElections::Models::Admin`
#

RSpec.describe BitcoinCourseMonitoring::Models::Admin do
  include BitcoinCourseMonitoring::Models::AdminSpecHelper
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    let(:params) { attributes_for(:admin) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end

    context 'when id is specified' do
      let(:params) { attributes_for(:admin, id: 1) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when name is not specified' do
      let(:params) { attributes_for(:admin).except(:name) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when name is nil' do
      let(:params) { attributes_for(:admin, name: nil) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when login is not specified' do
      let(:params) { attributes_for(:admin).except(:login) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when login is nil' do
      let(:params) { attributes_for(:admin, login: nil) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when login isn\'t nil but already exists' do
      let!(:admin_one) { create(:admin, login: 'NumberOne')}
      let(:params) { attributes_for(:admin, login: 'NumberOne') }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }.to raise_error(Sequel::UniqueConstraintViolation)
      end
    end

    context 'when salt is not specified' do
      let(:params) { attributes_for(:admin).except(:salt) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when salt is nil' do
      let(:params) { attributes_for(:admin, salt: nil) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when password_hash is not specified' do
      let(:params) { attributes_for(:admin).except(:password_hash) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when password_hash is nil' do
      let(:params) { attributes_for(:admin, password_hash: nil) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end
  end

  describe 'instance of the model' do
    subject(:instance) { create(:admin) }

    methods =
      %i(name login salt password_hash id password? update)
    it { is_expected.to respond_to(*methods) }
  end

  describe '#name' do
    subject(:result) { instance.name }

    let(:instance) { create(:admin) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#login' do
    subject(:result) { instance.login }

    let(:instance) { create(:admin) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#salt' do
    subject(:result) { instance.salt }

    let(:instance) { create(:admin) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Sequel::SQL::Blob) }
    end
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:admin) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#password_hash' do
    subject(:result) { instance.password_hash }

    let(:instance) { create(:admin) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Sequel::SQL::Blob) }
    end
  end

  describe '#password?' do
    subject(:result) { instance.password?(password) }

    let(:instance) { create(:admin, password_hash: password_hash, salt: salt) }
    let(:password_hash) { make_password(password_admin, salt) }
    let(:salt) { SecureRandom.random_bytes(32) }
    let(:password_admin) { 'AbCd' }
    let(:password) { 'AbCd' }

    describe 'when password is correct' do
      subject { result }

      it { is_expected.to be_truthy }
    end

    describe 'when password is incorrect' do
      let(:password) { 'FghJ'}
      subject { result }

      it { is_expected.to be_falsey }
    end
  end

  describe '#update' do
    subject(:result) { instance.update(params) }

    let(:instance) { create(:admin) }

    context 'when id is specified' do
      let(:params) { { id: 1 } }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when name is nil' do
      let(:params) { { name: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when login is nil' do
      let(:params) { { login: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when login isn\'t nil but already exists' do
      let!(:admin_one) { create(:admin, login: 'NumberOne')}
      let(:params) { { login: 'NumberOne' } }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }.to raise_error(Sequel::UniqueConstraintViolation)
      end
    end

    context 'when salt is nil' do
      let(:params) { { salt: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when password_hash is nil' do
      let(:params) { { password_hash: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end
  end
end
