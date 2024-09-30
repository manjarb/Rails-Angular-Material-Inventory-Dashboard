require 'rails_helper'

RSpec.describe PaginationUtils do
  describe '.pagination_meta' do
    let(:paginated_collection) do
      OpenStruct.new(
        current_page: 1,
        total_pages: 5,
        total_count: 100,
        next_page: 2,
        prev_page: nil
      )
    end
    let(:limit) { 20 }

    it 'returns the correct metadata for a paginated collection' do
      meta = PaginationUtils.pagination_meta(paginated_collection, limit)

      expect(meta[:current_page]).to eq(1)
      expect(meta[:total_pages]).to eq(5)
      expect(meta[:total_count]).to eq(100)
      expect(meta[:limit]).to eq(20)
      expect(meta[:next_page]).to eq(2)
      expect(meta[:prev_page]).to be_nil
    end
  end

  describe '.paginate_array' do
    let(:items) { (1..50).to_a } # Array of integers for testing

    context 'when on the first page' do
      let(:page) { 1 }
      let(:per_page) { 10 }

      it 'paginates the array correctly' do
        paginated_result = PaginationUtils.paginate_array(items, page, per_page)

        expect(paginated_result.current_page).to eq(1)
        expect(paginated_result.total_pages).to eq(5)
        expect(paginated_result.total_count).to eq(50)
        expect(paginated_result.limit).to eq(10)
        expect(paginated_result.next_page).to eq(2)
        expect(paginated_result.prev_page).to be_nil
        expect(paginated_result.items).to eq((1..10).to_a)
      end
    end

    context 'when on a middle page' do
      let(:page) { 3 }
      let(:per_page) { 10 }

      it 'returns the correct paginated result' do
        paginated_result = PaginationUtils.paginate_array(items, page, per_page)

        expect(paginated_result.current_page).to eq(3)
        expect(paginated_result.total_pages).to eq(5)
        expect(paginated_result.total_count).to eq(50)
        expect(paginated_result.limit).to eq(10)
        expect(paginated_result.next_page).to eq(4)
        expect(paginated_result.prev_page).to eq(2)
        expect(paginated_result.items).to eq((21..30).to_a)
      end
    end

    context 'when on the last page with partial results' do
      let(:page) { 5 }
      let(:per_page) { 10 }

      it 'returns the correct paginated result' do
        paginated_result = PaginationUtils.paginate_array(items, page, per_page)

        expect(paginated_result.current_page).to eq(5)
        expect(paginated_result.total_pages).to eq(5)
        expect(paginated_result.total_count).to eq(50)
        expect(paginated_result.limit).to eq(10)
        expect(paginated_result.next_page).to be_nil
        expect(paginated_result.prev_page).to eq(4)
        expect(paginated_result.items).to eq((41..50).to_a)
      end
    end
  end

  describe '.extract_pagination_params' do
    let(:default_page) { 1 }
    let(:default_limit) { 20 }

    context 'when params contain valid page and limit' do
      let(:params) { { page: 2, limit: 15 } }

      it 'returns the correct page and limit' do
        pagination = PaginationUtils.extract_pagination_params(params, default_page, default_limit)

        expect(pagination[:page]).to eq(2)
        expect(pagination[:limit]).to eq(15)
      end
    end

    context 'when params contain invalid page and limit' do
      let(:params) { { page: -1, limit: 0 } }

      it 'returns the default page and limit' do
        pagination = PaginationUtils.extract_pagination_params(params, default_page, default_limit)

        expect(pagination[:page]).to eq(1)
        expect(pagination[:limit]).to eq(20)
      end
    end

    context 'when params are empty' do
      let(:params) { {} }

      it 'returns the default page and limit' do
        pagination = PaginationUtils.extract_pagination_params(params, default_page, default_limit)

        expect(pagination[:page]).to eq(1)
        expect(pagination[:limit]).to eq(20)
      end
    end
  end
end
