# encoding: utf-8

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл тестирования модели учетной записи торгов
# `BitcoinCourseMonitoring::Models::Trade`
#

RSpec.describe BitcoinCourseMonitoring::Models::Trade do
  let!(:user) { create(:user) }

  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    let(:params) { attributes_for(:trade).merge(user_id: user.id) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end

    context 'when id is specified' do
      let(:params) { attributes_for(:trade, id: 1).merge(user_id: user.id) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when key is not specified' do
      let(:params) { attributes_for(:trade).except(:key).merge(user_id: user.id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when key is nil' do
      let(:params) { attributes_for(:trade, key: nil).merge(user_id: user.id) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when secret is not specified' do
      let(:params) { attributes_for(:trade).except(:secret).merge(user_id: user.id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when secret is nil' do
      let(:params) { attributes_for(:trade, secret: nil).merge(user_id: user.id)}

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when margin is not specified' do
      let(:params) { attributes_for(:trade).except(:margin).merge(user_id: user.id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when margin is nil' do
      let(:params) { attributes_for(:trade, margin: nil).merge(user_id: user.id) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when order_price is not specified' do
      let(:params) { attributes_for(:trade).except(:order_price).merge(user_id: user.id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when order_price is nil' do
      let(:params) { attributes_for(:trade, order_price: nil) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when user_id is not specified' do
      let(:params) { attributes_for(:trade) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when user_id is nil' do
      let(:params) { attributes_for(:trade, user_id: nil) }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when user_id is not present in table users' do
      let(:params) {  attributes_for(:trade, user_id: 3000)  }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }.to raise_error(Sequel::ForeignKeyConstraintViolation)
      end
    end

    context 'when start_course is not specified' do
      let(:params) { attributes_for(:trade).except(:start_course).merge(user_id: user.id) }

      it 'should be equal to default' do
        expect(subject.start_course).to eq(0)
      end
    end

    context 'when closed is not specified' do
      let(:params) { attributes_for(:trade).merge(user_id: user.id) }

      it 'should be equal to default' do
        expect(subject.closed).to eq(false)
      end
    end
  end

  describe 'instance of the model' do
    subject(:instance) { create(:trade) }

    methods =
      %i(key secret start_course margin order_price closed id user_id update user)
    it { is_expected.to respond_to(*methods) }
  end

  describe '#key' do
    subject(:result) { instance.key }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#secret' do
    subject(:result) { instance.secret }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#start_course' do
    subject(:result) { instance.start_course }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Float) }
    end
  end

  describe '#margin' do
    subject(:result) { instance.margin }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Float) }
    end
  end

  describe '#order_price' do
    subject(:result) { instance.order_price }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Float) }
    end
  end

  describe '#closed' do
    subject(:result) { instance.closed }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(FalseClass) }
    end
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#user_id' do
    subject(:result) { instance.user_id }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#user' do
    subject(:result) { instance.user }

    let(:instance) { create(:trade) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(BitcoinCourseMonitoring::Models::User) }

      it 'should be a record this record belongs to' do
        expect(result.id).to be == instance.user_id
      end
    end
  end

  describe '#update' do
    subject(:result) { instance.update(params) }

    let(:instance) { create(:trade) }

    context 'when id is specified' do
      let(:params) { { id: 1 } }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when key is nil' do
      let(:params) { { key: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when secret is nil' do
      let(:params) { { secret: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when margin is nil' do
      let(:params) { { margin: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when order_price is nil' do
      let(:params) { { order_price: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when closed is nil' do
      let(:params) { { closed: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when user_id is nil' do
      let(:params) { { user_id: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when user_id is not present in table users' do
      let(:params) { { user_id: 3000 } }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }.to raise_error(Sequel::ForeignKeyConstraintViolation)
      end
    end
  end
end
