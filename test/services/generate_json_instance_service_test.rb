require 'test_helper'

class GenerateJsonInstanceServiceTest < ActiveSupport::TestCase
  test 'should generate date' do
    json = GenerateJsonInstanceService.new({ type: 'string', format: 'date' }).execute
    begin
      date = Date.parse(json)
    rescue ArgumentError
      date = nil
    end
    assert date
  end

  test 'should generate datetime' do
    json = GenerateJsonInstanceService.new({ type: 'string', format: 'datetime' }).execute
    begin
      date = DateTime.parse(json)
    rescue ArgumentError
      date = nil
    end
    assert date
  end

  test 'should generate empty body if json_schema is nil' do
    assert_equal '', GenerateJsonInstanceService.new(nil).execute
  end

  test 'should generate multiplier_for_durations array of object' do
    schema = {
      "additionalProperties": false,
      "definitions": {
        "CompanyCoupon_1030": {
          "additionalProperties": false,
          "description": 'Automatically generated (please edit me)',
          "properties": {
            "offer": {
              "$ref": '#/definitions/DefaultOffer_1025',
              "description": 'CompanyCoupon offer',
              "type": 'object'
            }
          },
          "required": [
            'offer',
          ],
          "title": 'Coupon - CompanyCoupon',
          "type": 'object'
        },
        "DefaultOffer_1025": {
          "additionalProperties": false,
          "description": 'Automatically generated (please edit me)',
          "properties": {
            "multiplier_for_durations": {
              "description": "\tList of offer’s possible durations localized string along with the corresponding multiplier",
              "items": {
                "type": 'object'
              },
              "type": 'array'
            }
          },
          "required": [
            'multiplier_for_durations',
          ],
          "title": 'Offer - DefaultOffer',
          "type": 'object'
        }
      },
      "description": 'Automatically generated (please edit me)',
      "properties": {
        "subscription": {
          "additionalProperties": false,
          "properties": {
            "resume_coupon": {
              "$ref": '#/definitions/CompanyCoupon_1030',
              "description": 'Subscription resume coupon',
              "type": 'object'
            },
          },
          "required": [
            'resume_coupon',
          ],
          "type": 'object'
        }
      },
      "required": [
        'subscription'
      ],
      "title": 'Subscription - DefaultSubscription',
      "type": 'object'
    }
    json = GenerateJsonInstanceService.new(schema).execute
    assert_not_nil json.dig('subscription', 'resume_coupon', 'offer', 'multiplier_for_durations')
  end

  test 'should not loop' do
    schema = {
      "title": 'InternationalProduct - DefaultInternationalProduct',
      "type": 'object',
      "properties": {
        "amount_to_deliver": {
          "type": 'number'
        },
        "delivered_amount": {
          "type": 'number'
        },
        "invoiced_amount": {
          "type": 'number'
        },
        "id": {
          "type": 'string'
        },
        "label": {
          "type": 'string'
        },
        "orderlines": {
          "type": 'array',
          "items": {
            "type": 'object',
            "$ref": '#/definitions/InternationalProductOrderLine_1065'
          }
        }
      },
      "additionalProperties": false,
      "description": 'Automatically generated (please edit me)',
      "required": [
        'amount_to_deliver',
        'delivered_amount',
        'id',
        'invoiced_amount',
        'label',
        'orderlines'
      ],
      "definitions": {
        "InternationalProductOrderLine_1065": {
          "title": 'InternationalOrderLine - InternationalProductOrderLine',
          "type": 'object',
          "properties": {
            "unit": {
              "type": 'string'
            },
            "delivery_note_number": {
              "type": 'string'
            },
            "packaging": {
              "type": 'string'
            },
            "invoice_number": {
              "type": 'string'
            },
            "currency": {
              "type": 'string'
            },
            "id": {
              "type": 'string'
            },
            "unit_price": {
              "type": 'number'
            },
            "amount_delivered": {
              "type": 'number'
            },
            "total_amount": {
              "type": 'number'
            },
            "due_date": {
              "type": 'string',
              "format": 'date'
            },
            "delivery_date": {
              "type": 'string',
              "format": 'date'
            },
            "invoice_date": {
              "type": 'string',
              "format": 'date'
            },
            "order": {
              "type": 'object',
              "$ref": '#/definitions/DefaultInternationalOrder_950'
            }
          },
          "additionalProperties": false,
          "description": 'Automatically generated (please edit me)',
          "required": [
            'amount_delivered',
            'currency',
            'delivery_date',
            'delivery_note_number',
            'due_date',
            'id',
            'invoice_date',
            'invoice_number',
            'order',
            'packaging',
            'total_amount',
            'unit',
            'unit_price'
          ]
        },
        "DefaultInternationalOrder_950": {
          "title": 'InternationalOrder - DefaultInternationalOrder',
          "type": 'object',
          "properties": {
            "order_lines": {
              "type": 'array',
              "items": {
                "type": 'object',
                "$ref": '#/definitions/InternationalOrderOrderLine_951'
              }
            },
            "company_label": {
              "type": 'string'
            },
            "date": {
              "type": 'string',
              "format": 'date'
            },
            "id": {
              "type": 'string'
            },
            "settled": {
              "type": 'boolean'
            },
            "status": {
              "type": 'string',
              "enum": [
                'ordered',
                'delivered',
                'invoiced'
              ]
            }
          },
          "additionalProperties": false,
          "description": 'Automatically generated (please edit me)',
          "required": [
            'company_label',
            'date',
            'id',
            'order_lines',
            'settled',
            'status'
          ]
        },
        "InternationalOrderOrderLine_951": {
          "title": 'InternationalOrderLine - InternationalOrderOrderLine',
          "type": 'object',
          "properties": {
            "invoice_date": {
              "type": 'string',
              "format": 'date'
            },
            "delivery_date": {
              "type": 'string',
              "format": 'date'
            },
            "due_date": {
              "type": 'string',
              "format": 'date'
            },
            "total_amount": {
              "type": 'number'
            },
            "amount_delivered": {
              "type": 'number'
            },
            "unit_price": {
              "type": 'number'
            },
            "id": {
              "type": 'string'
            },
            "currency": {
              "type": 'string'
            },
            "invoice_number": {
              "type": 'string'
            },
            "packaging": {
              "type": 'string'
            },
            "delivery_note_number": {
              "type": 'string'
            },
            "unit": {
              "type": 'string'
            },
            "product": {
              "type": 'object',
              "$ref": '#/definitions/DefaultInternationalProduct_952'
            }
          },
          "additionalProperties": false,
          "description": 'Automatically generated (please edit me)',
          "required": [
            'amount_delivered',
            'currency',
            'delivery_date',
            'delivery_note_number',
            'due_date',
            'id',
            'invoice_date',
            'invoice_number',
            'packaging',
            'product',
            'total_amount',
            'unit',
            'unit_price'
          ]
        },
        "DefaultInternationalProduct_952": {
          "title": 'InternationalProduct - DefaultInternationalProduct',
          "type": 'object',
          "properties": {
            "amount_to_deliver": {
              "type": 'number'
            },
            "delivered_amount": {
              "type": 'number'
            },
            "invoiced_amount": {
              "type": 'number'
            },
            "id": {
              "type": 'string'
            },
            "label": {
              "type": 'string'
            },
            "orderlines": {
              "type": 'array',
              "items": {
                "type": 'object',
                "$ref": '#/definitions/InternationalProductOrderLine_1065'
              }
            }
          },
          "additionalProperties": false,
          "description": 'Automatically generated (please edit me)',
          "required": [
            'amount_to_deliver',
            'delivered_amount',
            'id',
            'invoiced_amount',
            'label',
            'orderlines'
          ]
        }
      }
    }

    assert_not_looping do
      GenerateJsonInstanceService.new(schema).execute
    end
  end
end
