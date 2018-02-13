# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл тестирования модели учетной записи пользователя
# `BitcoinCourseMonitoring::Models::User`
#

RSpec.describe BitcoinCourseMonitoring::Models::User do
  include BitcoinCourseMonitoring::Models::UserSpecHelper
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    let(:params) { attributes_for(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end

    context 'when id is specified' do
      let(:params) { attributes_for(:user, id: 1) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when login is not specified' do
      let(:params) { attributes_for(:user).except(:login) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when login is nil' do
      let(:params) { attributes_for(:user, login: nil) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when login isn\'t nil but already exists' do
      let!(:admin_one) { create(:user, login: 'NumberOne')}
      let(:params) { attributes_for(:user, login: 'NumberOne') }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }.to raise_error(Sequel::UniqueConstraintViolation)
      end
    end
  end

  describe 'instance of the model' do
    subject(:instance) { create(:user) }

    methods =
      %i(role login salt password_hash id created_at password? update setup_password trades)
    it { is_expected.to respond_to(*methods) }
  end

  describe '#role' do
    subject(:result) { instance.role }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#login' do
    subject(:result) { instance.login }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#created_at' do
    subject(:result) { instance.created_at }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#salt' do
    subject(:result) { instance.salt }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Sequel::SQL::Blob) }
    end
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#password_hash' do
    subject(:result) { instance.password_hash }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Sequel::SQL::Blob) }
    end
  end

  describe '#password?' do
    subject(:result) { instance.password?(password) }

    let(:instance) { create(:user, password_hash: password_hash, salt: salt) }
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

  describe '#setup_password' do
    subject { instance.setup_password }

    let!(:instance) { create(:user) }
    let(:user) { BitcoinCourseMonitoring::Models::User.first }

    context 'should change salt' do
      it { expect { subject }.to change { user.reload.salt }}
    end

    context 'should change password_hash' do
      it { expect { subject }.to change { user.reload.password_hash }}
    end
  end

  describe '#trades' do
    subject(:result) { instance.trades }

    let(:instance) { create(:user) }
    let!(:trades) { create_list(:trade, 2, user: instance) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Array) }
      it { is_expected.to all(be_a(BitcoinCourseMonitoring::Models::Trade)) }

      it 'should be a list of question belonging to the user' do
        expect(subject.map(&:user_id).uniq).to be == [instance.id]
      end
    end
  end

  describe '#trades_dataset' do
    subject(:result) { instance.trades_dataset }

    let(:instance) { create(:user) }
    let!(:trades) { create_list(:trade, 2, user: instance) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Sequel::Dataset) }

      it 'should be a dataset of BitcoinCourseMonitoring::Models::Trade instances' do
        expect(result.model).to be == BitcoinCourseMonitoring::Models::Trade
      end

      it 'should be a dataset of records belonging to the instance' do
        expect(result.select_map(:user_id).uniq).to be == [instance.id]
      end
    end
  end

  describe '#update' do
    subject(:result) { instance.update(params) }

    let(:instance) { create(:user) }

    context 'when id is specified' do
      let(:params) { { id: 1 } }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when login is nil' do
      let(:params) { { login: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when login isn\'t nil but already exists' do
      let!(:admin_one) { create(:user, login: 'NumberOne')}
      let(:params) { { login: 'NumberOne' } }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }.to raise_error(Sequel::UniqueConstraintViolation)
      end
    end
  end
end
