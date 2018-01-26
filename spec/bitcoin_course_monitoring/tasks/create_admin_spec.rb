# encoding: utf-8

require "#{$lib}/tasks/create_admin"

# @author Алейников Максим <m.v.aleinikov@gmail.com>
#
# Файл тестирования rake задачи на создание учетной записи администротора
# `BitcoinCourseMonitoring::Tasks::CreateAdmin`
#

RSpec.describe BitcoinCourseMonitoring::Tasks::CreateAdmin do
  subject { described_class }

  it { is_expected.to respond_to(:launch!) }

  describe '.launch!' do
   subject { described_class.launch! }

   let(:admins) { BitcoinCourseMonitoring::Models::Admin }

   describe 'when no admin records exist' do
     it 'should create a new record in IElections::Models::Admin' do
       expect { subject }.to change { admins.count }.from(0).to(1)
     end
   end

   describe 'when there are admin records' do
     context 'when there is one record entry in the database' do
       before do
         create(:admin)
       end

       let!(:admin) { admins.first }

       it 'should not create a new record in IElections::Models::Admin' do
         expect { subject }.to_not change { admins.count }
       end

       it 'should update record in IElections::Models::Admin' do
         expect { subject }.to change { admin.reload.values }
       end
     end
     context 'when there are several records in the database' do
       before do
         create_list(:admin, 5)
       end

       let(:admin) { admins.order(:id).first }

       it 'should not create a new record in IElections::Models::Admin' do
         expect { subject }.to_not change { admins.count }
       end

       it 'should update record with the smallest identifier' do
         expect { subject }.to change { admin.reload.values }
       end
     end
   end
  end
end
