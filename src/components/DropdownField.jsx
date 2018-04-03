import React from 'react';
import PropTypes from 'prop-types';
import { Dropdown, DropdownToggle, DropdownMenu, DropdownItem } from 'reactstrap';

class DropdownField extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      dropdownIsOpen: false,
      selectedItem: Object.keys(this.props.items)[0],
    };
  }

  componentWillMount() {
    this.findAndSelectItem(this.props.items);
  }

  componentWillReceiveProps(nextProps) {
    const { items } = this.props;
    const { items: nextItems } = nextProps;
    if (
      items.length !== nextItems.length ||
      JSON.stringify(items) !== JSON.stringify(nextItems)
    ) {
      this.findAndSelectItem(nextProps.items);
    }
  }

  selectItem = (itemKey, item) => {
    const { items, onSelect } = this.props;
    this.setState({ selectedItem: itemKey });
    if (onSelect) onSelect(item || items[itemKey]);
  }

  toggle = () => {
    this.setState({ dropdownIsOpen: !this.state.dropdownIsOpen });
  }

  findAndSelectItem = (items) => {
    const itemKey = Object.keys(items).find(key => (
      typeof items[key] !== 'object' ||
      !['disabled', 'divider', 'header'].some(prop => items[key][prop])
    ));
    this.selectItem(itemKey, items[itemKey]);
  }

  render() {
    const { className, items, style } = this.props;
    const { dropdownIsOpen, selectedItem } = this.state;
    const itemsKeys = Object.keys(items);

    return (
      <Dropdown
        className={className}
        isOpen={dropdownIsOpen}
        toggle={this.toggle}
        style={style}
      >
        <div className={dropdownIsOpen ? 'dropup' : ''}>
          <DropdownToggle caret>
            {
              typeof items[selectedItem] === 'object'
              ? items[selectedItem].title
              : items[selectedItem]
            }
          </DropdownToggle>
        </div>
        <DropdownMenu>
          {
            Object.values(items).map((item, index) => {
              const itemProps = {};
              let title = '';
              if (typeof item === 'object') {
                if (item.divider) return <DropdownItem divider key={index} />;
                title = item.title;
                if (
                  !Object.keys(item).some((prop) => {
                    if (['disabled', 'header'].includes(prop)) {
                      itemProps[prop] = item[prop];
                      return true;
                    }
                    return false;
                  })
                ) {
                  itemProps.onClick = () => this.selectItem(itemsKeys[index]);
                }
              } else {
                title = item;
                itemProps.onClick = () => this.selectItem(itemsKeys[index]);
              }
              return (
                <DropdownItem key={index} {...itemProps}>
                  { title }
                </DropdownItem>
              );
            })
          }
        </DropdownMenu>
      </Dropdown>
    );
  }
}

DropdownField.defaultProps = {
  className: null,
  items: [],
  onSelect: null,
  style: null,
};

DropdownField.propTypes = {
  className: PropTypes.string,
  items: PropTypes.oneOfType([
    PropTypes.arrayOf(
      PropTypes.oneOfType([
        PropTypes.shape({
          disabled: PropTypes.bool,
          divider: PropTypes.bool,
          header: PropTypes.bool,
          title: PropTypes.string,
        }),
        PropTypes.string,
      ]),
    ),
    PropTypes.objectOf(
      PropTypes.oneOfType([
        PropTypes.shape({
          disabled: PropTypes.bool,
          divider: PropTypes.bool,
          header: PropTypes.bool,
          title: PropTypes.string,
        }),
        PropTypes.string,
      ]),
    ),
  ]),
  onSelect: PropTypes.func,
  style: PropTypes.object,
};

export default DropdownField;
